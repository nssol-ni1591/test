package util;

import java.util.Collections;
import java.util.Enumeration;
import java.util.stream.Collectors;

public class Attribute {

	private String key;
	private String value;

	public Attribute(String key, String value) {
		this.key = key;
		this. value = value;
	}
	public Attribute(String key, Object value) {
		this.key = key;
		this. value = value.toString();
	}
	public Attribute(String key, Enumeration<String> e) {
		this.key = key;
		this.value = Collections.list(e).stream().collect(Collectors.joining(","));
	}
	public Attribute(String key, String[] array) {
		this.key = key;
		this.value = String.join(",", array);
	}
	
	public String getKey() {
		return key;
	}
	public String getValue() {
		return value;
	}
}
