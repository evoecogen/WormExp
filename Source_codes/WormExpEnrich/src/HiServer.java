package com.dem.test;


import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;
 
//启动RMI注册服务，并注册远程对象（HiServer.java）
public class HiServer {
 
	 public static void main(String[] argv)     
	   {     
	      try    
	      {     
	         //启动RMI注册服务，指定端口为1099　（1099为默认端口）     
	         //也可以通过命令 ＄java_home/bin/rmiregistry 1099启动     
	         //这里用这种方式避免了再打开一个DOS窗口     
	         //而且用命令rmiregistry启动注册服务还必须事先用RMIC生成一个stub类为它所用     
	         LocateRegistry.createRegistry(1099);     
 
	         //创建远程对象的一个或多个实例，下面是hello对象     
	         //可以用不同名字注册不同的实例     
	         WEInterface hi = new Hi("Hello, world!");     
 
	         //把hi注册到RMI注册服务器上，命名为A
	         Naming.rebind("A", hi);     //客户端通过这个A来寻找
 
	         //如果要把hi实例注册到另一台启动了RMI注册服务的机器上     
	         //Naming.rebind("//192.168.1.105:1099/A",hi);     
 
	         System.out.println("Hi Server is ready.");     
	      }     
	      catch (Exception e)     
	      {     
	         System.out.println("Hi Server failed: " + e);     
	      }     
	   }     
 
}
