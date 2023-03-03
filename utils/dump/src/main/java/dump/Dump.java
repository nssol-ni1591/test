package dump;

import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.Vector;

public class Dump implements Serializable {

	private static final long serialVersionUID = 1L;
	static ResourceBundle bundle = null;
	static {
		try {
			bundle = ResourceBundle.getBundle("dump");
		}
		catch (MissingResourceException ex) {
			System.out.println(ex.getMessage());
		}
	}

	private static String getProperty(String key) {
		if (bundle == null) {
			return null;
		}
		try {
			return bundle.getString(key);
		}
		catch (Exception ex) {}
		return null;
	}

    public static void printClass(Object o, String n) {
		printClass(o, n, 0);
	}
	private static void printClass(Object o, String n, int num) {

		StringBuffer indent = new StringBuffer();
		for (int ix= 0; ix < num; ix++) {
			indent.append("|  ");
		}

		if (o == null) {
			System.out.println(indent + n + " => object is null");
			return;
		}
		if (n != null && n.startsWith("this$")) {
//			System.out.println(indent + "  => reference of inner class?");
			return;
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
		Arrays.stream(fields)
			.filter(f -> {
				try {
					printClass(f.get(o), f.getName(), num + 1);
					return false;
				}
				catch (IllegalAccessException ex) { }
				return true;
			})
			.filter(f -> {
				String name = "get" + f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1) ;
				try {
					Method m = c.getDeclaredMethod(name, new Class[] { });
					Object obj = m.invoke(o, new Object[] { });
					printClass(obj, f.getName(), num + 1);
					return false;
				}
				catch (Exception ex) { }
				return true;
			})
			.filter(f -> {
				String name = getProperty(f.getName());
				if (name == null) { }
				else try {
					Method m = c.getDeclaredMethod(name, new Class[] { });
					Object obj = m.invoke(o, new Object[] { });
					printClass(obj, f.getName(), num + 1);
					return false;
				}
				catch (Exception ex) { }
				return true;
			})
			.forEach(f -> {
				String msg = "An inaccessible field and getter is not found";
				System.out.println(indent + "|  " + f.getName() + " => " + msg);
			});
	}

	/*
	 * For debug
	 */
	public static void main(String[] args) {

		Object o = new Dump();
		Dump.printClass(o, "o");

		System.out.println("----");
		try {
//			FileOutputStream outputStream = new FileOutputStream("dump.bin");
			ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
			ObjectOutputStream objectOutputStream = new ObjectOutputStream(outputStream);

			objectOutputStream.writeObject(o);
//			objectOutputStream.flush();
			objectOutputStream.close();
			
			System.out.println(">>> Serialize successful");
		}
		catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	private String s;
	private Vector<String> v;
	private Map<String, Object> m;
	private DumpSub sub;

	public Dump() {
		this.s = "abc";
		this.v = new Vector<>();
		this.v.add("a");
		this.v.add(s);
		this.sub = new DumpSub();
		this.m = new HashMap<>();
		this.m.put("a", "a");
		this.m.put("c", new DumpSub());
		this.m.put("d", sub);
	}

	public class DumpSub implements Serializable {

		private static final long serialVersionUID = 1L;
		private List<String> list;
		private DumpArray[] array;
		private DumpSub parent;

		public DumpSub() {
			this.list = new ArrayList<>();
			this.list.add("0");
			this.list.add("1");

			this.array = new DumpArray[] { new DumpArray("A"), new DumpArray("B") };
		}

		public List<String> getList() {
			return list;
		}
		public DumpArray[] getArray() {
			return array;
		}
		public DumpSub getParent() {
			return parent;
		}
	}

	public class DumpList extends ArrayList<String> {

		private static final long serialVersionUID = -6517253125595161761L;
		private Long obj;

		public DumpList() {
			this.add("xyz");
			this.obj = (long) 0;
		}
		public Long getObject() {
			return obj;
		}
	}

	public class DumpArray implements Serializable {
		
		private static final long serialVersionUID = 4887294429199769982L;
		Object o;

		public DumpArray(String s) {
			o = s;
		}
	}
}
