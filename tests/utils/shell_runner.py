"""
Shell 命令执行器
用于运行 bash 脚本并捕获输出
"""
import subprocess
import os
from pathlib import Path
from typing import Optional, Dict, Any, Tuple


class ShellRunner:
    """运行 bash 命令和脚本的工具类"""

    @staticmethod
    def run_command(
        cmd: str,
        cwd: Optional[Path] = None,
        env: Optional[Dict[str, str]] = None,
        timeout: int = 30
    ) -> Tuple[int, str, str]:
        """
        运行 bash 命令

        Args:
            cmd: 命令字符串
            cwd: 工作目录
            env: 环境变量
            timeout: 超时时间（秒）

        Returns:
            (return_code, stdout, stderr) 元组
        """
        try:
            result = subprocess.run(
                cmd,
                shell=True,
                cwd=cwd,
                env={**os.environ, **(env or {})},
                capture_output=True,
                text=True,
                timeout=timeout
            )
            return result.returncode, result.stdout, result.stderr
        except subprocess.TimeoutExpired:
            return -1, "", f"Command timed out after {timeout} seconds"
        except Exception as e:
            return -1, "", str(e)

    @staticmethod
    def run_script(
        script_path: Path,
        args: Optional[list] = None,
        cwd: Optional[Path] = None,
        input_data: Optional[str] = None,
        env: Optional[Dict[str, str]] = None,
        timeout: int = 60
    ) -> Tuple[int, str, str]:
        """
        运行 bash 脚本

        Args:
            script_path: 脚本路径
            args: 脚本参数列表
            cwd: 工作目录
            input_data: 标准输入数据
            env: 环境变量
            timeout: 超时时间（秒）

        Returns:
            (return_code, stdout, stderr) 元组
        """
        cmd = ["bash", str(script_path)]
        if args:
            cmd.extend(args)

        try:
            result = subprocess.run(
                cmd,
                cwd=cwd,
                input=input_data,
                capture_output=True,
                text=True,
                timeout=timeout,
                env={**os.environ, **(env or {})}
            )
            return result.returncode, result.stdout, result.stderr
        except subprocess.TimeoutExpired:
            return -1, "", f"Script timed out after {timeout} seconds"
        except Exception as e:
            return -1, "", str(e)

    @staticmethod
    def run_script_with_input(
        script_path: Path,
        inputs: list[str],
        cwd: Optional[Path] = None,
        timeout: int = 60
    ) -> Tuple[int, str, str]:
        """
        运行脚本并提供多个输入（用于交互式脚本）

        Args:
            script_path: 脚本路径
            inputs: 输入列表（每个元素对应一次 read）
            cwd: 工作目录
            timeout: 超时时间

        Returns:
            (return_code, stdout, stderr) 元组
        """
        # 将多个输入用换行符连接
        input_data = "\n".join(inputs) + "\n"
        return ShellRunner.run_script(script_path, cwd=cwd, input_data=input_data, timeout=timeout)