import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;


public class TraceFileGen extends JFrame implements ActionListener{
	 
	JLabel size_label, 
		info_label, 
		info_label2,
		f_label,
		ram_label,
		c_label;
	
	JTextField size_field,
			f_field,
			ram_field,
			c_field;
	
	JButton make_button;
	
	Random r;
	
	long size, last, mmsize;
	float prob;
	
	public TraceFileGen(){
		r = new Random();
		
		setLayout(new GridLayout(0,2));
		info_label = new JLabel("Enter Desired Values");
		info_label2 = new JLabel("Made by: Ian Glow");

		f_label = new JLabel("Enter File Name:");
		f_field = new JTextField();
		
		size_label = new JLabel("Enter # of traces:");
		size_field = new JTextField();
		
		ram_label = new JLabel("Enter size of mm in MB:");
		ram_field = new JTextField();
		
		c_label = new JLabel("<html>Enter Probabilty of<br>continuious memory acces(0.0-1.0):</html>");
		c_field = new JTextField();
		
		make_button = new JButton("Create");
		make_button.addActionListener(this);
		
		add(info_label2);
		add(new JLabel());
		
		add(f_label);
		add(f_field);
		
		add(ram_label);
		add(ram_field);
		
		add(c_label);
		add(c_field);
		
		add(size_label);
		add(size_field);
		
		add(new JLabel());
		add(make_button);
		
		setSize(500, 300);
		setResizable(false);
		setVisible(true);
		
	}


	@Override
	public void actionPerformed(ActionEvent arg0) {
		size = Long.parseLong(size_field.getText());
		prob = Float.parseFloat(c_field.getText());
		mmsize = Long.parseLong(ram_field.getText()) * 1024 * 1024;
		
		System.out.println("Creating Trace File " + f_field.getText() + " of length " + size);
		
		try
		{
		  BufferedWriter w = new BufferedWriter(new FileWriter(new File(f_field.getText())));
		  for(int i = 0; i < size; i++)
		  {
			  if(i < size - 1)
				  w.write(makeHex() + "\n");
			  else
				  w.write(makeHex());
		  }
		  w.flush();
		  w.close();
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
	}
	
	private String makeHex() {
		boolean cont = (!(last == 0) && r.nextFloat() < prob);
		
		long n = 0;
		
		if(!cont)
			n = r.nextInt((int) mmsize);// % ;
		else
			n = (last + 1) % mmsize;
		
		String out = "0x";
		String hex = Long.toHexString(n);
		
		last = n;
		
		return out + hex;
	}


	public static void main(String[] args) {
		 new TraceFileGen();
	}


}
