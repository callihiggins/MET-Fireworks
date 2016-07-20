import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;

/* Tweak of *@*http://www.openprocessing.org/sketch/92345*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */


import java.util.*;

import codeanticode.syphon.*;

ArrayList fires;
ArrayList particles;
PGraphics canvas;
SyphonServer server;
Timer timer;

Twitter twitter;
String searchString = "#metfest";
List<Status> tweets;
Status lastTweet;
int currentTweet, year, month, day, timePassed, oldSize, second;
long lastId;
boolean firstTime;


void setup() {
  size(800, 800, P3D);
  colorMode(HSB);
  noStroke();
  smooth();
  fires = new ArrayList();
  particles = new ArrayList();
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
  openTwitterStream();
  timer = new Timer(8000); // 8 seconds
  timer.start();
  firstTime = true;
}

void draw() {
  timePassed = millis();
  fill(color(0, 0, 0), 25);    //Transparent black (25%  opacity)
  rect(0, 0, width, height);    //Erases background, automaticaly drawing tails  

  for (int i = fires.size ()-1; i >=0; i--) {
    Fire fire = (Fire) fires.get(i);
    if (fire.draw()==false) {
      fires.remove(i);
    }
  }

  for (int i = particles.size ()-1; i >=0; i--) {
    Particle particle = (Particle) particles.get(i);
    if (particle.draw()==false) {
      particles.remove(i);
    }
  }

  if (timer.isFinished()) {
    thread("getNewTweets");
    timer.start();
  }


  /* random generation
   int randomnum = int(random(500));
   if (randomnum < 10) {
   fires.add(new Fire(mouseX, 0, BOMB, color(10, 255, 255), (int) random(0, 255), random(.5, 3), int(random(50, 100)), random(0, 1.2), random(1, 2), int(random(4))));
   }
   */

  server.sendScreen();
}

void mousePressed() {
  fires.add(new Fire(mouseX, 0, type, color(10, 255, 255), (int) random(0, 255), random(.5, 3), int(random(50, 100)), random(0, 1.2), random(1, 2), int(random(4))));
}

// Stream it
void openTwitterStream() {  

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("CONSUMER KEY");
  cb.setOAuthConsumerSecret("CONSUMER SECRET");
  cb.setOAuthAccessToken("ACCESS TOKEN");
  cb.setOAuthAccessTokenSecret("TOKEN SECCRET");

  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();

  getNewTweets();

  currentTweet = 0;

  thread("getNewTweets");

  println("connected");
} 


void getNewTweets()
{
  try
  {
    Query query = new Query(searchString);
    query.count(100);
    query.resultType(Query.RECENT);
    println("last id: " + lastId);
    if (lastId != 0) query.setSinceId(lastId);

    QueryResult result = twitter.search(query);

    tweets = result.getTweets();
    println("total tweets: " + tweets.size());
    if (tweets.size() > 0 && !firstTime) {
      // lastTweet = tweets.get(0);
      for (int i = 0; i < tweets.size(); i++) {
        fires.add(new Fire(mouseX, 0, type, color(10, 255, 255), (int) random(0, 255), random(.5, 3), int(random(50, 100)), random(0, 1.2), random(1, 2), int(random(4))));
        delay(int(random(100, 800)));
      }
      lastId = result.getMaxId();
      println(lastId);
    }
    firstTime = false;
  }
  catch (TwitterException te)
  {
    System.out.println("Failed to search tweets: " + te.getMessage());
  //  System.exit(-1);
  }
}
