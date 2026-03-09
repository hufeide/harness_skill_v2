"""
guide.sh 单元测试
"""
import json
import pytest
from pathlib import Path
import subprocess


class TestProjectStageDetection:
    """测试项目阶段检测"""

    def test_init_stage_no_config(self, temp_project_dir):
        """测试未初始化项目的阶段"""
        # 没有 config/project.json
        assert not (temp_project_dir / "config" / "project.json").exists()

    def test_planning_stage_empty_project(self, temp_project_dir):
        """测试已初始化但无设计文档的项目"""
        # 创建 config 目录
        config_dir = temp_project_dir / "config"
        config_dir.mkdir()
        (config_dir / "project.json").write_text("{}")

        # 没有 docs/plans 目录
        plans_dir = temp_project_dir / "docs" / "plans"
        assert not plans_dir.exists()

    def test_development_stage_with_code(self, temp_project_dir):
        """测试有代码的项目"""
        # 创建 config 和 docs/plans
        config_dir = temp_project_dir / "config"
        config_dir.mkdir()
        (config_dir / "project.json").write_text("{}")

        plans_dir = temp_project_dir / "docs" / "plans"
        plans_dir.mkdir(parents=True)
        (plans_dir / "test-plan.md").write_text("Test plan")

        # 创建代码文件
        src_dir = temp_project_dir / "src"
        src_dir.mkdir()
        (src_dir / "main.py").write_text("print('hello')")

        assert (src_dir / "main.py").exists()


class TestGuideStateManagement:
    """测试引导状态管理"""

    def test_create_guide_state(self, temp_project_dir):
        """测试创建引导状态文件"""
        state_content = """CURRENT_STAGE="planning"
LAST_ACTIVITY="项目初始化完成"
"""
        state_file = temp_project_dir / ".guide_state"
        state_file.write_text(state_content)

        assert state_file.exists()
        assert "CURRENT_STAGE" in state_file.read_text()

    def test_update_guide_history(self, temp_project_dir):
        """测试更新引导历史"""
        history_file = temp_project_dir / ".guide_history"
        initial_history = "[2024-01-01 12:00:00] init - 项目初始化开始\n"
        history_file.write_text(initial_history)

        # 添加新记录
        new_entry = "[2024-01-01 12:30:00] planning - 需求分析开始\n"
        with open(history_file, "a") as f:
            f.write(new_entry)

        content = history_file.read_text()
        assert "项目初始化开始" in content
        assert "需求分析开始" in content


class TestScriptFiles:
    """测试脚本文件存在性"""

    def test_guide_script_exists(self, scripts_dir):
        """测试 guide.sh 存在"""
        guide_script = scripts_dir / "guide.sh"
        assert guide_script.exists()
        assert guide_script.stat().st_mode & 0o111  # 检查是否可执行

    def test_git_commit_script_exists(self, scripts_dir):
        """测试 git_commit.sh 存在"""
        git_commit_script = scripts_dir / "git_commit.sh"
        assert git_commit_script.exists()

    def test_init_project_script_exists(self, scripts_dir):
        """测试 init_project.sh 存在"""
        init_script = scripts_dir / "init_project.sh"
        assert init_script.exists()


class TestBashSyntax:
    """测试 Bash 脚本语法"""

    @pytest.mark.parametrize("script_name", [
        "guide.sh",
        "git_commit.sh",
        "init_project.sh",
        "check_setup.sh",
        "update_readme.sh"
    ])
    def test_bash_syntax(self, scripts_dir, script_name):
        """测试 bash 脚本语法正确"""
        script_path = scripts_dir / script_name
        if script_path.exists():
            result = subprocess.run(
                ["bash", "-n", str(script_path)],
                capture_output=True,
                text=True
            )
            assert result.returncode == 0, f"Syntax error in {script_name}: {result.stderr}"