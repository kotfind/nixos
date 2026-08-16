#!/usr/bin/env python3

import os
from pathlib import Path

from click import argument, echo, group, style
from desktop_notifier import DesktopNotifierSync
from platformdirs import PlatformDirs
from Xlib import X, display
from Xlib.error import DisplayConnectionError, DisplayNameError

APP_NAME: str = "notify-on-exit"
DIRS: PlatformDirs = PlatformDirs(appname=APP_NAME)


def _process_exists(pid: int) -> bool:
    """Return whether the given process exists."""

    try:
        os.kill(pid, 0)
    except ProcessLookupError:
        return False
    except PermissionError:
        return True
    return True


class LockFile:
    """Per-shell disable state."""

    def gc(self) -> None:
        """Remove locks left behind by dead shells."""

        dir = self._get_lock_dir()
        for file in dir.iterdir():
            pid = int(file.name)
            if not _process_exists(pid):
                file.unlink(missing_ok=True)

    def create(self) -> None:
        """Mark notifications as disabled for the current shell."""

        self._get_lock_file().touch()

    def remove(self) -> None:
        """Mark notifications as enabled for the current shell."""

        self._get_lock_file().unlink(missing_ok=True)

    def exists(self) -> bool:
        """Return whether notifications are disabled for the current shell."""

        return self._get_lock_file().exists()

    def _get_lock_dir(self) -> Path:
        """Return the lock directory."""

        path = DIRS.user_runtime_path
        path.mkdir(mode=0o700, parents=True, exist_ok=True)
        return path

    def _shell_pid(self) -> int:
        """Return the pid of the invoking shell."""

        return os.getppid()

    def _get_lock_file(self) -> Path:
        """Return the lock file path for the current shell."""

        return self._get_lock_dir() / str(self._shell_pid())


def get_terminal_wid() -> int | None:
    """Return the terminal window id, or None if unknown."""

    terminal_wid = os.environ.get("WINDOWID")
    if terminal_wid is None:
        return None

    return int(terminal_wid, 0)


def get_focused_wid() -> int | None:
    """Return the focused window id, or None when unknown."""

    try:
        d = display.Display()
    except (DisplayConnectionError, DisplayNameError):
        return None

    focus = d.get_input_focus().focus
    focus_wid = focus.id if not isinstance(focus, int) else focus

    if focus_wid in (X.NONE, X.PointerRoot):
        return None

    return focus_wid


@group(context_settings={"help_option_names": ["-h", "--help"]})
def cli() -> None:
    """
    Notify when a command exits in the terminal.

    The `hook` subcommand should be registered as a post-execution hook.
    It sends a desktop notification whenever a command finishes while
    the terminal window is not focused.

    Examples:

    \b
      blehook POSTEXEC+='/path/to/notify-on-exit.py hook "$?" "$1"'
    """


@cli.command()
def enable() -> None:
    """Enable notifications for the current shell."""

    LockFile().remove()


@cli.command()
def disable() -> None:
    """Disable notifications for the current shell."""

    LockFile().create()


@cli.command()
def status() -> None:
    """Print whether notifications are enabled or disabled."""

    lock = LockFile()
    lock.gc()
    if lock.exists():
        echo(style("disabled", fg="red", bold=True))
    else:
        echo(style("enabled", fg="green", bold=True))


@cli.command()
@argument("status", type=int)
@argument("command")
def hook(status: int, command: str) -> None:
    """Send a notification if the terminal window is not focused."""

    lock = LockFile()
    if lock.exists():
        return

    terminal_wid = get_terminal_wid()
    focused_wid = get_focused_wid()
    if terminal_wid is None or focused_wid is None:
        return

    if terminal_wid == focused_wid:
        return

    if status == 0:
        app_name = "command-executed"
        title = "Command executed"
    else:
        app_name = "command-failed"
        title = f"Command failed (status: {status})"

    notifier = DesktopNotifierSync(app_name, app_icon=None)
    notifier.send(title=title, message=command)


if __name__ == "__main__":
    cli()
