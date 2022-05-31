package homework;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.*;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import java.util.*;

public class arrowhero extends JPanel implements MouseListener, KeyListener, Runnable {
	public static int gameState = 0; // game states
	public static int mouseX; // gets position of x
	public static int mouseY; // gets position of y
	public static int health = 100; // health of player
	public static int angle = -91; // angle of the rotating object starts at -90 since we need the object to start
									// at the top of the screen, and when I tried
	// 90 it went to the bottom so I tried -90 and it worked so im keeping it at
	// that
	public static int count = 1; // this variable is to make the object move faster and faster, it is used along
									// counter in order to make the object move faster after a certain ammount of
									// spins
	public static int counter = 1800; // using count, i subtract counter form count, and since count gets bigger every
										// angle, it will take approxipately, counter/360 spins before the object moves
										// faster
	public static int arrow = 0;// variable for which arrowkey
	public static LinkedList<Arrow> arrows = new LinkedList<Arrow>(); // 1, 4, 3, 2, 1, 1, 2
	public static int time = 0;
	public static int spawnTime = 300;
	public static int decrease = 2;
	public static int score = 0;
	public static int scoreAddition = 0;
	
	BufferedImage menuScreen; // menu screen image
	BufferedImage arrowup; // object image(s) but not done yet
	BufferedImage arrowdown; // object image(s) but not done yet
	BufferedImage arrowleft; // object image(s) but not done yet
	BufferedImage arrowright; // object image(s) but not done yet
	public static BufferedImage [] images;

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		JFrame myFrame = new JFrame("Arrowhero");

		// Create a panel to put inside the frame
		arrowhero myPanel = new arrowhero();
		myFrame.add(myPanel);

		// Maximize your frame to the size of the panel
		myFrame.pack();

		// Set the visibility of the frame to visible
		myFrame.setVisible(true);
	}

	public arrowhero() {
		setPreferredSize(new Dimension(680,928)); // 320, 240 b288.5, 213
		setBackground(new Color(255, 255, 255));
		this.setFocusable(true);
		addKeyListener(this);
		try {
			
			menuScreen = ImageIO.read(new File("Arrow_Master_1.png"));
			images = new BufferedImage [5];
			images[2] = ImageIO.read(new File("uparrow.png"));
			images[4] = ImageIO.read(new File("downarrow.png"));
			images[1] = ImageIO.read(new File("leftarrow.png"));
			images[3] = ImageIO.read(new File("rightarrow.png"));
			
		} catch (Exception e) {
			System.out.println("no image");

		}
		addMouseListener(this);
		Thread thread = new Thread(this);
		thread.start();
		// game states
		// 1 menu screen ( menu, cosmetics, keybinds)
		// 2 game screen
		// win/lose screen
	}



	public void paintComponent(Graphics g) {
		if (gameState == 0) {
			g.drawImage(menuScreen, 0, 0, null);
		} else if (gameState == 1) {
			super.paintComponent(g);
			
			// g.drawImage(menuScreen, 0, 0, 800, 800, this);
			for(int i=0; i <arrows.size(); i++) {
				System.out.println(arrows.get(i).position);
				arrows.get(i).position -= count;
				g.drawImage(images[arrows.get(i).type], (int) (288 + 200 * Math.cos(arrows.get(i).position * Math.PI / 180)),
						(int) (213 + 200 * Math.sin(arrows.get(i).position * Math.PI / 180)), this);

			}
			counter -= count;
			if (counter < 0) {
				count++;
				counter = 1800;
			}

		}

	}

	@Override
	public void run() {
		while (true) {
			repaint();
			try {
				Thread.sleep(16); // The commands after while(true) but before try will execute once every 80
									// milliseconds
				
				if (gameState == 1) {
					if(time== spawnTime) {
						arrows.add(new Arrow(angle, ((int)(Math.random()*(4-1+1))+1)));
						time= 0;
						spawnTime-=decrease;
					}
					time++;
						if(!arrows.isEmpty()&& arrows.peek().position==-451) {
							if(arrows.peek().type == arrow) {
								score+= scoreAddition;
								scoreAddition++;
							}
							else {
								health-=5;
							}
							arrows.poll();
						}
						if (health < 0) {
							gameState = 2;
						}

					
					
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}

	@Override
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void keyPressed(KeyEvent e) {
		// TODO Auto-generated method stub
		if (e.getKeyCode() >= 37 && e.getKeyCode() <= 40) {
			arrow = e.getKeyCode() - 36;
		}
	}

	@Override
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
		mouseX = e.getX();
		mouseY = e.getY();
		if (gameState == 0) {
			if (0 <= mouseX && mouseX <= 680 && 0 <= mouseY && mouseY <= 928) {
				gameState = 1;
				paintComponent(this.getGraphics());
			}
		}
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	// x pos is radius * cossine of angle
	// y pos is the radius * sine of the angle
	public static class Arrow{
		int position;
		int type;
		
		public Arrow (int px, int tx) {
			position = px;
			type = tx;
		}
	}
}
