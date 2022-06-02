/*
 * コンパイル：
 * C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe Highlight.cs
 */

using System;
using System.Diagnostics;
//using System.Windows.Interop;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Threading;

class Highlight
{
	//using System.Runtime.InteropServices;

	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	private static extern bool SetForegroundWindow(IntPtr hWnd);

	public static void SetActiveWindow(string title, int time = 5) {
		//すべてのプロセスを列挙する
		foreach (Process p in Process.GetProcesses()) {
			string t = p.MainWindowTitle;
			if (String.IsNullOrWhiteSpace(t)) {
				continue;
			}
//			if (t.StartsWith(title)) {
			if (t.IndexOf(title) >= 0) {
				//ウィンドウをアクティブにする
				SetForegroundWindow(p.MainWindowHandle);
//				Console.WriteLine("[" + DateTime.Now + "] Info: Foreground Window (title=[" + title + "] time=[" + time + "])");
//				Console.WriteLine($"[{DateTime.Now}] Info: Foreground Window (title=[{title}] time=[{time}])");
				string s = string.Format("[{0}] Info: Foreground Window (title=[{1}] time=[{2}])", DateTime.Now, title, time);
				Console.WriteLine(s);
				Thread.Sleep(time * 1000);
				return;
			}
		}

		Console.WriteLine("[" + DateTime.Now + "] Error: Title of [* " + title + " *] not found");
		dispProcess();
		Environment.Exit(1);
	}

	public static void dispProcess() {
		foreach (Process p in Process.GetProcesses()) {
			string t = p.MainWindowTitle;
			if (!String.IsNullOrWhiteSpace(t)) {
				Console.WriteLine("Debug: Title=[" + t + "]");
			}
		}
	}

	public static void usage(string cmd, string[] msgs) {
		foreach (string msg in msgs) {
			Console.WriteLine("Error: " + msg);
		}
		Console.WriteLine("usage: {0} title", cmd);
		dispProcess();
		Environment.Exit(1);
	}

	/// <summary>
	/// エントリポイント
	/// </summary>
	public static void Main(string[] args) {
		string cmd = System.Diagnostics.Process.GetCurrentProcess().ProcessName;
		if (args.Length < 1) {
			usage(cmd, new string[] { "requied title of program" });
		}
		string target = args[0];
		Random r = new Random();
		while (true) {
//		  Task.Delay(60 * 1000);
//			SetActiveWindow("次期RINDA");
			SetActiveWindow("RINDA Mattermost");
//			Thread.Sleep(5 * 1000);
//			SetActiveWindow("コマンド プロンプト - Highlight");
			SetActiveWindow(" " + cmd, r.Next(45, 90));
//			Thread.Sleep(r.Next(45, 90) * 1000);
		}
	}
}

