#!/usr/bin/env python3
"""Copy videos from a source playlist to a destination playlist, skipping duplicates.

This uses the YouTube Data API v3. You must provide OAuth client secrets and
have access to both playlists.
"""

from __future__ import annotations

import argparse
import time
from pathlib import Path
from typing import Iterable

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

SCOPES = ["https://www.googleapis.com/auth/youtube"]


def get_authenticated_service(client_secrets: Path, token_path: Path):
    creds = None
    if token_path.exists():
        creds = Credentials.from_authorized_user_file(token_path, SCOPES)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                str(client_secrets), 
                SCOPES,
                redirect_uri="urn:ietf:wg:oauth:2.0:oob"
            )
            auth_url, _ = flow.authorization_url(prompt="consent", access_type="offline")
            print(f"\nPlease visit this URL to authorize:\n{auth_url}\n")
            code = input("Enter the authorization code: ").strip()
            flow.fetch_token(code=code)
            creds = flow.credentials
        token_path.write_text(creds.to_json())
    return build("youtube", "v3", credentials=creds)


def iter_playlist_video_ids(youtube, playlist_id: str) -> Iterable[str]:
    request = youtube.playlistItems().list(
        part="contentDetails",
        playlistId=playlist_id,
        maxResults=50,
    )
    while request is not None:
        response = request.execute()
        for item in response.get("items", []):
            video_id = item.get("contentDetails", {}).get("videoId")
            if video_id:
                yield video_id
        request = youtube.playlistItems().list_next(request, response)


def add_video_to_playlist(youtube, playlist_id: str, video_id: str):
    body = {
        "snippet": {
            "playlistId": playlist_id,
            "resourceId": {
                "kind": "youtube#video",
                "videoId": video_id,
            },
        }
    }
    return (
        youtube.playlistItems()
        .insert(part="snippet", body=body)
        .execute()
    )


def copy_playlist_items(
    youtube,
    source_playlist_id: str,
    dest_playlist_id: str,
    dry_run: bool,
) -> tuple[int, int]:
    print("Fetching existing items from destination playlist...")
    existing = set(iter_playlist_video_ids(youtube, dest_playlist_id))
    print(f"Found {len(existing)} items in destination.")
    
    added = 0
    skipped = 0

    print("Fetching items from source playlist...")
    for video_id in iter_playlist_video_ids(youtube, source_playlist_id):
        if video_id in existing:
            skipped += 1
            continue
        if dry_run:
            print(f"[dry-run] Would add {video_id}")
        else:
            try:
                print(f"Adding {video_id}...")
                add_video_to_playlist(youtube, dest_playlist_id, video_id)
                time.sleep(0.5)  # Rate limit: 2 requests per second
            except HttpError as exc:
                print(f"Failed to add {video_id}: {exc}")
                continue
        existing.add(video_id)
        added += 1

    return added, skipped


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Copy items from a source playlist to a destination playlist, "
            "skipping duplicates."
        )
    )
    parser.add_argument(
        "--client-secrets",
        required=True,
        type=Path,
        help="Path to OAuth client secrets JSON.",
    )
    parser.add_argument(
        "--token",
        default=Path(".ytmusic_token.json"),
        type=Path,
        help="Path to store OAuth token JSON.",
    )
    parser.add_argument(
        "--source-playlist",
        required=True,
        help=(
            "Source playlist ID (for YouTube Music Liked Songs, some accounts "
            "use playlist ID 'LM')."
        ),
    )
    parser.add_argument(
        "--dest-playlist",
        required=True,
        help="Destination playlist ID.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="List what would be added without modifying the destination.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    youtube = get_authenticated_service(args.client_secrets, args.token)
    added, skipped = copy_playlist_items(
        youtube,
        args.source_playlist,
        args.dest_playlist,
        args.dry_run,
    )
    print(f"Done. Added: {added}, skipped: {skipped}")


if __name__ == "__main__":
    main()
