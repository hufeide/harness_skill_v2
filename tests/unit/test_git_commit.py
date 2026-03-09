"""
git_commit.sh 单元测试
"""
import json
import pytest
from pathlib import Path
from unittest.mock import patch, MagicMock


class TestGithubUrlParsing:
    """测试 GitHub URL 解析功能"""

    def test_parse_valid_github_url(self, temp_project_dir):
        """测试解析有效的 GitHub URL"""
        config = {
            "github": {
                "url": "https://github.com/hufeide/test4"
            }
        }
        config_path = temp_project_dir / "config" / "project.json"
        config_path.parent.mkdir()
        with open(config_path, "w") as f:
            json.dump(config, f)

        # 模拟 jq 命令解析
        result = subprocess.run(
            ["jq", "-r", ".github.url", str(config_path)],
            capture_output=True, text=True
        )
        assert result.returncode == 0
        assert result.stdout.strip() == "https://github.com/hufeide/test4"

    def test_parse_url_without_git_suffix(self, temp_project_dir):
        """测试移除 .git 后缀"""
        url_with_git = "https://github.com/hufeide/test4.git"
        url_without_git = url_with_git.rstrip(".git")
        assert url_without_git == "https://github.com/hufeide/test4"

    def test_missing_github_url(self, temp_project_dir):
        """测试缺少 GitHub URL 的情况"""
        config = {
            "github": {
                "user": "testuser"
                # 缺少 url 字段
            }
        }
        config_path = temp_project_dir / "config" / "project.json"
        config_path.parent.mkdir()
        with open(config_path, "w") as f:
            json.dump(config, f)

        result = subprocess.run(
            ["jq", "-r", ".github.url", str(config_path)],
            capture_output=True, text=True
        )
        assert result.stdout.strip() == "null"


class TestGitOperations:
    """测试 Git 操作功能"""

    def test_git_init(self, temp_project_dir):
        """测试 Git 仓库初始化"""
        result = subprocess.run(
            ["git", "init"],
            cwd=temp_project_dir,
            capture_output=True,
            text=True
        )
        assert result.returncode == 0
        assert (temp_project_dir / ".git").exists()

    def test_git_branch_main(self, temp_project_dir):
        """测试创建 main 分支"""
        subprocess.run(["git", "init"], cwd=temp_project_dir, check=True)
        result = subprocess.run(
            ["git", "branch", "-M", "main"],
            cwd=temp_project_dir,
            capture_output=True,
            text=True
        )
        assert result.returncode == 0

    def test_git_config_user(self, temp_project_dir):
        """测试配置 Git 用户信息"""
        subprocess.run(["git", "init"], cwd=temp_project_dir, check=True)
        subprocess.run(["git", "config", "user.name", "Test User"], cwd=temp_project_dir, check=True)
        subprocess.run(["git", "config", "user.email", "test@example.com"], cwd=temp_project_dir, check=True)

        result = subprocess.run(
            ["git", "config", "user.name"],
            cwd=temp_project_dir,
            capture_output=True,
            text=True
        )
        assert result.stdout.strip() == "Test User"


class TestRemoteConfiguration:
    """测试远程仓库配置"""

    def test_add_remote_origin(self, temp_project_dir):
        """测试添加远程仓库 origin"""
        subprocess.run(["git", "init"], cwd=temp_project_dir, check=True)
        github_url = "https://github.com/testuser/test-repo"

        result = subprocess.run(
            ["git", "remote", "add", "origin", github_url],
            cwd=temp_project_dir,
            capture_output=True,
            text=True
        )
        assert result.returncode == 0

        # 验证远程仓库已添加
        result = subprocess.run(
            ["git", "remote", "get-url", "origin"],
            cwd=temp_project_dir,
            capture_output=True,
            text=True
        )
        assert result.stdout.strip() == github_url

    def test_update_existing_remote(self, temp_project_dir):
        """测试更新现有远程仓库"""
        subprocess.run(["git", "init"], cwd=temp_project_dir, check=True)
        old_url = "https://github.com/olduser/old-repo"
        new_url = "https://github.com/newuser/new-repo"

        # 先添加旧远程
        subprocess.run(["git", "remote", "add", "origin", old_url], cwd=temp_project_dir, check=True)

        # 更新远程
        result = subprocess.run(
            ["git", "remote", "set-url", "origin", new_url],
            cwd=temp_project_dir,
            capture_output=True,
            text=True
        )
        assert result.returncode == 0

        # 验证已更新
        result = subprocess.run(
            ["git", "remote", "get-url", "origin"],
            cwd=temp_project_dir,
            capture_output=True,
            text=True
        )
        assert result.stdout.strip() == new_url


class TestScriptExecution:
    """测试脚本执行"""

    @pytest.mark.skip(reason="需要交互式输入，在 CI 环境中难以测试")
    def test_git_commit_script_execution(self, init_sample_project, git_commit_script, script_runner):
        """测试 git_commit.sh 脚本执行"""
        returncode, stdout, stderr = script_runner.run_script_with_input(
            git_commit_script,
            inputs=["feat: test commit"],
            cwd=init_sample_project
        )
        # 注意：实际测试需要 mock git push
        assert returncode == 0 or "no changes" in stdout.lower()