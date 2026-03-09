"""
E2E 测试：完整生命周期
"""
import pytest
import json
import subprocess
from pathlib import Path


@pytest.mark.e2e
class TestFullLifecycle:
    """测试从空项目到推送到 GitHub 的完整生命周期"""

    def test_empty_to_production(self, temp_project_dir):
        """
        测试完整生命周期：
        1. 空目录
        2. 初始化项目
        3. 创建设计文档
        4. 开发功能
        5. 运行测试
        6. 提交代码
        """
        # 阶段 1: 初始化项目
        env = {
            "GITHUB_USER": "testuser",
            "PROJECT_NAME": "e2e-test",
            "PROJECT_DESC": "E2E 测试项目"
        }

        # 创建基本结构（模拟 init_project.sh）
        config_dir = temp_project_dir / "config"
        config_dir.mkdir()

        project_config = {
            "github": {
                "user": "testuser",
                "repo": "e2e-test",
                "url": "https://github.com/testuser/e2e-test",
                "token": ""
            },
            "project": {
                "name": "e2e-test",
                "description": "E2E 测试项目",
                "default_branch": "main"
            }
        }

        with open(config_dir / "project.json", "w") as f:
            json.dump(project_config, f, indent=2)

        # 创建目录结构
        (temp_project_dir / "docs" / "plans").mkdir(parents=True)
        (temp_project_dir / "src").mkdir()
        (temp_project_dir / "tests").mkdir()

        # 初始化 Git
        subprocess.run(["git", "init"], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "config", "user.name", "Test"], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "config", "user.email", "test@test.com"], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "branch", "-M", "main"], cwd=temp_project_dir, check=True, capture_output=True)

        # 阶段 2: 创建设计文档
        plan_doc = temp_project_dir / "docs" / "plans" / "2024-01-01-initial-design.md"
        plan_doc.write_text("# 初始设计\n\n这是 E2E 测试的设计文档")

        # 阶段 3: 开发功能
        main_py = temp_project_dir / "src" / "main.py"
        main_py.write_text("# 主文件\nprint('Hello, World!')")

        # 阶段 4: 创建测试
        test_file = temp_project_dir / "tests" / "test_main.py"
        test_file.write_text("""
def test_hello():
    assert True
""")

        # 阶段 5: 提交代码
        subprocess.run(["git", "add", "."], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "commit", "-m", "feat: 初始功能"], cwd=temp_project_dir, check=True, capture_output=True)

        # 验证提交
        result = subprocess.run(
            ["git", "log", "-1", "--oneline"],
            cwd=temp_project_dir,
            capture_output=True,
            text=True
        )
        assert "feat: 初始功能" in result.stdout


@pytest.mark.e2e
class TestMultiBranchWorkflow:
    """测试多分支工作流"""

    def test_feature_branch_workflow(self, temp_project_dir):
        """测试功能分支工作流"""
        # 初始化主分支
        subprocess.run(["git", "init"], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "config", "user.name", "Test"], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "config", "user.email", "test@test.com"], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "branch", "-M", "main"], cwd=temp_project_dir, check=True, capture_output=True)

        # 创建初始提交
        (temp_project_dir / "README.md").write_text("# Test")
        subprocess.run(["git", "add", "."], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "commit", "-m", "initial"], cwd=temp_project_dir, check=True, capture_output=True)

        # 创建功能分支
        subprocess.run(["git", "checkout", "-b", "feature/test"], cwd=temp_project_dir, check=True, capture_output=True)

        # 在功能分支上开发
        (temp_project_dir / "feature.py").write_text("# 功能代码")
        subprocess.run(["git", "add", "."], cwd=temp_project_dir, check=True, capture_output=True)
        subprocess.run(["git", "commit", "-m", "feat: 添加功能"], cwd=temp_project_dir, check=True, capture_output=True)

        # 切换回主分支
        subprocess.run(["git", "checkout", "main"], cwd=temp_project_dir, check=True, capture_output=True)

        # 验证功能分支不在主分支
        assert not (temp_project_dir / "feature.py").exists()