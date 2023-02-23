/*
 * コンパイル：
 * C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe Highlight.cs
 */

using System;
using System.Collections.Generic;
using System.Diagnostics;
//using System.Drawing;
//using System.Windows.Interop;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Threading;

class Highlight
{
	//using System.Runtime.InteropServices;

	private static Random RAND = new Random();
	private static int TIME = 5;

	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	private static extern bool SetForegroundWindow(IntPtr hWnd);

//----
	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	private static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

	[DllImport("user32.dll", SetLastError = true)]
	[return: MarshalAs(UnmanagedType.Bool)]
	private static extern bool SetWindowPos(IntPtr hWnd,
    	int hWndInsertAfter, int x, int y, int w, int h, int uFlags);

	[StructLayout(LayoutKind.Sequential)]
	public struct RECT {
		public int left;		// x position of upper-left corner
		public int top;			// y position of upper-left corner
		public int right;		// x position of lower-right corner
		public int bottom;		// y position of lower-right corner
	}

	// values of uFlags
	private const int SWP_NOSIZE = 0x0001;
	private const int SWP_NOMOVE = 0x0002;
	private const int SWP_SHOWWINDOW = 0x0040;

	private const int HWND_TOP = 0;
	private const int HWND_TOPMOST = -1;
	private const int HWND_NOTOPMOST = -2;
//----

	private static List<Process> listProcesses() {
		var list = new List<Process>();

		//すべてのプロセスを列挙する
		foreach (Process p in Process.GetProcesses()) {
			string t = p.MainWindowTitle;
			if (String.IsNullOrWhiteSpace(t)) {
				continue;
			}
			list.Add(p);
		}
		return list;
	}

	public static bool setActiveWindow(string title, string except_str) {
		//すべてのプロセスを列挙する
		foreach (Process p in listProcesses()) {
			string t = p.MainWindowTitle;
			if (t.IndexOf(title) < 0) { }
			else if (t.IndexOf(except_str) < 0) {
				//ウィンドウをアクティブにする
				SetForegroundWindow(p.MainWindowHandle);

				string s = string.Format("[{0}] Info: Active Window (t=[{1}])", DateTime.Now, t);
				Console.WriteLine(s);
				Thread.Sleep(TIME * 1000);
				return true;
			}
		}
		return false;
	}
	public static bool setActiveWindow(string title, int time) {
		//すべてのプロセスを列挙する
		foreach (Process p in listProcesses()) {
			string t = p.MainWindowTitle;
			if (t.IndexOf(title) >= 0) {
				//ウィンドウをアクティブにする
				SetForegroundWindow(p.MainWindowHandle);

				string s = string.Format("[{0}] Info: Active Window (t=[{1}] time=[{2}])", DateTime.Now, t, time);
				Console.WriteLine(s);
				Thread.Sleep(time * 1000);
				return true;
			}
		}

		Console.WriteLine("[{0}] Error: Window not found (title=[{1}])", DateTime.Now, title);
		dispProcess();
		Environment.Exit(1);
		return false;
	}
	public static bool setActiveWindow(string[] targets, string cmd) {
		foreach (string target in targets) {
			if (setActiveWindow(target, cmd)) {
				// targetのWindowが見つかった場合
				setActiveWindow(cmd, RAND.Next(45, 90));
				return true;
			}
		}
		return false;
	}

	public static void setRightBottomWindow(string cmd) {
		moveWindow(cmd, -1, -1);
	}
	public static void moveWindow(string title, int x, int y) {
		foreach (Process p in listProcesses()) {
			string t = p.MainWindowTitle;
			if (t.IndexOf(title) >= 0) {

				if (t.IndexOf(title + ".cs") >= 0) {
					Console.WriteLine("Info: Skip Window (title=[{0}])", t);
					continue;
				}

				IntPtr hWnd = p.MainWindowHandle;
				RECT r;

				if (!GetWindowRect(hWnd, out r)) {
					Console.WriteLine("Error: GetWindowRect");
					continue;
				}
				Console.WriteLine("Info: WindowRect (title=[{0}] left=[{1}] top=[{2}] right=[{3}] bottom=[{4}])", t, r.left, r.top, r.right, r.bottom);

				if (x < 0) {
					//ディスプレイの幅
					int w = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width;
					x = w - (r.right - r.left);
				}
				if (y < 0) {
					//ディスプレイの高さ
					int h = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height;
					y = h - (r.bottom - r.top);
				}

				SetWindowPos(hWnd, HWND_TOP, x, y, 0, 0, SWP_SHOWWINDOW | SWP_NOSIZE);
				Console.WriteLine("Info: WindowPos (title=[{0}] x=[{1}] y=[{2}])", t, x, y);
				break;
			}
		}
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
		Console.WriteLine("usage: {0} title ...", cmd);
		dispProcess();
		Environment.Exit(1);
	}

	/// <summary>
	/// エントリポイント
	/// </summary>
	public static void Main(string[] args) {
		string cmd = System.Diagnostics.Process.GetCurrentProcess().ProcessName;
		if (args.Length < 1) {
			usage(cmd, new string[] { "Requied Window's title" });
		}

		// ウィンドウの位置を画面右下に移動
		setRightBottomWindow(cmd);

		bool sleeping = false;
		while (true) {
			if (setActiveWindow(args, cmd)) {
				sleeping = false;
				continue;
			}

			// targetのWindowが見つからない場合
			if (!sleeping) {
				string s = string.Format("[{0}] Warn: Target window not found (title=[{1}])",
					DateTime.Now, string.Join(" ", args));
				Console.WriteLine(s);
				dispProcess();
				sleeping = true;
			}
			Thread.Sleep(30 * 1000);
		}
	}
}
