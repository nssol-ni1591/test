import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

public class Dump {

	public static void printClass(Object o, String n) {
		printClass(o, n, 0);
	}
	private static void printClass(Object o, String n, int num) {
		if (n != null && n.startsWith("this$")) {
//			System.out.println(indent + "  =>inner class?");
			return;
		}

		StringBuffer indent = new StringBuffer();
		for (int ix= 0; ix < num; ix++) {
			indent.append("|  ");
		}

		Class<? extends Object> c = o.getClass(); 
		System.out.println(indent.toString() + (n == null ? "???" : n) + " " + c.getName() + " serialize=" + (o instanceof Serializable));

		if (c.getName().startsWith("java.lang.")) {
			return;
		}

		if (o instanceof Collection) {
			System.out.println(indent.toString() + "| collection:");
			int ix = 0;
			Iterator<?> it = ((Collection<?>) o).iterator();
			while (it.hasNext()) {
				printClass(it.next() , "index=[" + ix + "]", num + 1);
				ix += 1;
			}
		}

		if (o instanceof Map) {
			System.out.println(indent.toString() + "| map:");
			Set<?> keys = ((Map<?, ?>) o).keySet();
			Iterator<?> it = keys.iterator();
			while (it.hasNext()) {
				Object key = it.next();
				printClass(((Map<?, ?>) o).get(key), "key=[" + key + "]", num + 1);
			}
		}

		if (o.getClass().isArray()) {
			System.out.println(indent.toString() + "| array:");
			Object array[] = (Object[])o;
			for (int ix = 0; ix < array.length; ix++) {
				printClass(array[ix] , "index=[" + ix + "]", num + 1);
			}
			return;	// Array has not fields
		}
		if (c.getName().startsWith("java.")) {
			return;
		}

		System.out.println(indent.toString() + "| fields:");
		Field[] fields = c.getDeclaredFields();
		for (int ix = 0; ix < fields.length; ix++) {
			Field f = fields[ix];
			String msg = null;
			try {
				printClass(f.get(o), f.getName(), num + 1);
			}
			catch (IllegalAccessException ex1) {

				String mname = "get" + f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1) ;
				try {
					Method m = c.getDeclaredMethod(mname, new Class[] { });
					Object obj = m.invoke(o, new Object[] { });
					printClass(obj, f.getName(), num + 1);
				}
				catch (Exception ex2) {
					msg = "An inaccessible field and getter is not found";
				}
			}
			if (msg != null) {
				System.out.println(indent + "|  " + f.getName() + " =>" + msg);
			}
		}
	}

	/*
	 * For debug
	 */
	public static void main(String[] args) {

		Object o = new Dump();
		Dump.printClass(o, "o");
	}

	private String s;
	private Vector<String> v;
	private Map<String, Object> m;
	private DumpSub sub;

	public Dump() {
		this.s = "abc";
		this.v = new Vector<>();
		this.v.add("a");
		this.v.add("b");
		this.sub = new DumpSub();
		this.m = new HashMap<>();
		this.m.put("a", "a");
//		this.m.put("b", "b");
		this.m.put("c", new DumpSub());
		this.m.put("d", new DumpList());
	}

	public class DumpSub {

		private List<String> list;
		private String[] array;
		private DumpSub parent;

		public DumpSub() {
			this.list = new ArrayList<>();
			this.list.add("a");
//			this.list.add("b");

			this.array = new String[] { "x", "y", "z" };
		}

		public List<String> getList() {
			return list;
		}
		public String[] getArray() {
			return array;
		}
	}

	public class DumpList extends ArrayList<String> {

		private static final long serialVersionUID = -7098015697676498053L;

		private String s;

		public DumpList() {
			this.add("xyz");
			this.s = "";
		}
		public String getS() {
			return s;
		}
	}
}
