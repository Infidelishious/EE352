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
	 //String hex = Integer.toHexString(val);
	JLabel size_label, 
		info_label, 
		info_label2,
		f_label;
	
	JTextField size_field,
			f_field;
	
	JButton make_button;
	
	Random r;
	
	long size;
	
	public TraceFileGen(){
		r = new Random();
		
		setLayout(new GridLayout(0,2));
		info_label = new JLabel("Enter Desired Values");
		info_label2 = new JLabel("Made by: Ian Glow");

		f_label = new JLabel("Enter File Name:");
		f_field = new JTextField();
		
		size_label = new JLabel("Enter # of traces:");
		size_field = new JTextField();
		
		make_button = new JButton("Create");
		make_button.addActionListener(this);
		
		add(info_label2);
		add(new JLabel());
		
		add(f_label);
		add(f_field);
		
		add(size_label);
		add(size_field);
		
		add(new JLabel());
		add(make_button);
		
		setSize(500, 200);
		setResizable(false);
		setVisible(true);
		
	}


	@Override
	public void actionPerformed(ActionEvent arg0) {
		size = Long.parseLong(size_field.getText());
		//ArrayList<String> trace = new ArrayList<String>();
		
			//trace.add();
		
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
		String out = "0x";
		
		for(int i = 0; i < 8; i++)
		{
			char c = 0;
			int k = r.nextInt(16);
			if(k < 10)
				c = (char) ('0' + k);
			else
				c = (char) ('a' + (k - 10));
			out += c;
		}
		return out;
	}


	public static void main(String[] args) {
		 new TraceFileGen();
	}


}
