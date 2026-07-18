"""
Notify about Claude Code status via desktop notification.

Hook input model reference:
https://code.claude.com/docs/en/hooks
"""

from __future__ import annotations

import os
import sys
from time import sleep
from abc import abstractmethod
from enum import StrEnum
from typing import Literal, NoReturn, Union

import notify2
from ewmh import EWMH
from pydantic import BaseModel, TypeAdapter, ValidationError
from systemd import journal
from Xlib.display import Display

SYSLOG_APP_NAME: str = "claude-hooks"
NOTIFY_APP_NAME: str = "claude-code"
DEBOUNCE_SECS: float = 0.3


# -------------------- Logging helpers --------------------


def log_(priority: int, msg: str) -> None:
    journal.send(msg, PRIORITY=priority, SYSLOG_APP_NAME=SYSLOG_APP_NAME)


def fatal(msg: str) -> NoReturn:
    log_(journal.LOG_CRIT, msg)
    sys.exit(1)


# -------------------- Hook models --------------------


class BaseHook(BaseModel):
    session_id: str
    cwd: str

    @abstractmethod
    def handle(self) -> None: ...

    @property
    def title(self) -> str:
        session = self.cwd.rsplit("/", 1)[-1]
        return f"Claude ({session})"

    def notify_(self, text: str) -> None:
        if is_focused():
            return

        ring_bell()
        notify(self.title, text)


class NotificationType(StrEnum):
    AGENT_COMPLETED = "agent_completed"
    AUTH_SUCCESS = "auth_success"
    ELICITATION_DIALOG = "elicitation_dialog"
    IDLE_PROMPT = "idle_prompt"
    PERMISSION_PROMPT = "permission_prompt"


class NotificationHook(BaseHook):
    hook_event_name: Literal["Notification"]
    message: str
    notification_type: NotificationType

    def handle(self) -> None:
        if self.notification_type == NotificationType.IDLE_PROMPT:
            return

        self.notify_(f"{self.notification_type}\n{self.message}")


class StopHook(BaseHook):
    hook_event_name: Literal["Stop"]

    def handle(self) -> None:
        self.notify_("Done")


Hook = Union[NotificationHook, StopHook]


def parse_hook(data: str) -> Hook:
    parser = TypeAdapter(Hook)

    try:
        return parser.validate_json(data)
    except ValidationError:
        fatal("unknown hook event")


# -------------------- Desktop helpers --------------------


def detach() -> None:
    if os.fork() != 0:
        sys.exit(0)
    os.setsid()


def is_gui() -> bool:
    return bool(os.environ.get("DISPLAY"))


def is_focused() -> bool:
    window_id = os.environ.get("WINDOWID", "")
    if not window_id:
        return False

    def check() -> bool:
        active = EWMH().getActiveWindow()
        if active is None:
            return False

        return active.id == int(window_id)

    if not check():
        return False

    detach()
    sleep(DEBOUNCE_SECS)

    return check()


def ring_bell() -> None:
    display = Display()
    display.bell(0, 0)
    display.flush()
    display.close()


def notify(title: str, text: str) -> None:
    notify2.init(NOTIFY_APP_NAME)
    notify2.Notification(title, text).show()


# -------------------- Main --------------------


def main() -> None:
    if not is_gui():
        sys.exit(0)

    hook = parse_hook(sys.stdin.read())
    hook.handle()


if __name__ == "__main__":
    main()
