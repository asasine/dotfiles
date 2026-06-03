use std::env;
use std::ffi::OsStr;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

fn main() {
    if let Err(err) = run() {
        eprintln!("git-wt-me: {err}");
        std::process::exit(1);
    }
}

fn run() -> Result<(), String> {
    let repo_root = git_output(["rev-parse", "--show-toplevel"])?;
    let current_branch = git_output(["branch", "--show-current"])?;
    if current_branch.is_empty() {
        return Err("not on a branch (detached HEAD)".to_string());
    }

    let name = env::args().nth(1).unwrap_or_else(|| default_name(&current_branch));

    let repo_root = PathBuf::from(repo_root);
    let repo_name = repo_root
        .file_name()
        .and_then(OsStr::to_str)
        .ok_or_else(|| "failed to determine repository directory name".to_string())?;
    let repo_parent = repo_root
        .parent()
        .ok_or_else(|| "failed to determine repository parent directory".to_string())?;

    let sibling_worktrees_dir = repo_parent.join(format!("{repo_name}.worktrees"));
    fs::create_dir_all(&sibling_worktrees_dir)
        .map_err(|e| format!("failed to create {}: {e}", display_path(&sibling_worktrees_dir)))?;

    let destination = sibling_worktrees_dir.join(name);

    // Move the current repository off the target branch before adding it as a worktree.
    git_status(["checkout", "main"])?;

    let status = Command::new("git")
        .args(["worktree", "add"])
        .arg(&destination)
        .arg(&current_branch)
        .status()
        .map_err(|e| format!("failed to run git worktree add: {e}"))?;

    if !status.success() {
        return Err(format!("git worktree add failed with status {status}"));
    }

    Ok(())
}

fn git_output<const N: usize>(args: [&str; N]) -> Result<String, String> {
    let output = Command::new("git")
        .args(args)
        .output()
        .map_err(|e| format!("failed to run git {}: {e}", args.join(" ")))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr).trim().to_string();
        if stderr.is_empty() {
            return Err(format!("git {} failed with status {}", args.join(" "), output.status));
        }
        return Err(stderr);
    }

    Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
}

fn git_status<const N: usize>(args: [&str; N]) -> Result<(), String> {
    let status = Command::new("git")
        .args(args)
        .status()
        .map_err(|e| format!("failed to run git {}: {e}", args.join(" ")))?;

    if !status.success() {
        return Err(format!("git {} failed with status {}", args.join(" "), status));
    }

    Ok(())
}

fn default_name(branch: &str) -> String {
    branch.rsplit('/').next().unwrap_or(branch).to_string()
}

fn display_path(path: &Path) -> String {
    path.to_string_lossy().to_string()
}
