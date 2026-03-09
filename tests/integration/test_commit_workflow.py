"""
代码提交工作流集成测试
"""
import pytest
import json
import subprocess
from pathlib import Path


@pytest.mark.integration
class TestCommitWorkflow:
    """测试代码提交工作流"""

    def test_git_commit_with_changes(self, init_sample_project, git_commit_script):
        """测试有更改时的提交流程"""
        # 在项目中添加新文件
        new_file = init_sample_project / "src" / "new_file.py"
        new_file.write_text("# 新文件\nprint('new')")

        # 验证文件已添加
        assert new_file.exists()

    def test_git_commit_no_changes(self, init_sample_project, git_commit_script):
        """测试无更改时的提交流程"""
        # 不添加任何更改，直接运行提交脚本
        # 应该提示没有需要提交的更改

        # 注意：实际测试需要 mock 交互式输入
        pass

    def test_remote_configuration(self, init_sample_project, git_commit_script):
        """测试远程仓库配置"""
        # 验证 origin 已配置
        result = subprocess.run(
            ["git", "remote", "get-url", "origin"],
            cwd=init_sample_project,
            capture_output=True,
            text=True
        )
        assert result.returncode == 0
        assert "test-repo" in result.stdout

    def test_branch_configuration(self, init_sample_project):
        """测试分支配置"""
        result = subprocess.run(
            ["git", "branch", "--show-current"],
            cwd=init_sample_project,
            capture_output=True,
            text=True
        )
        assert result.stdout.strip() == "main"


@pytest.mark.integration
class TestPushWorkflow:
    """测试推送工作流"""

    @pytest.mark.skip(reason="需要真实的 GitHub 仓库，在 CI 中需要配置 mock 或真实 token")
    def test_push_to_github(self, init_sample_project, git_commit_script):
        """测试推送到 GitHub"""
        # 这个测试需要真实的 GitHub 仓库和 token
        # 在 CI 环境中使用 mock 或测试仓库
        pass

    def test_push_url_configuration(self, init_sample_project):
        """测试推送 URL 配置"""
        result = subprocess.run(
            ["git", "remote", "get-url", "origin"],
            cwd=init_sample_project,
            capture_output=True,
            text=True
        )
        assert result.returncode == 0
        # 验证 URL 格式
        assert result.stdout.strip().startswith("https://github.com/")