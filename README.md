# vibe_connect

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



Build a robust meeting data workflow updatation in my app project  where:                                
                                                                                                            
    -- User starts a meeting and enters a title.(show a dialog box )                                            
                                                                                                             
   --  During the meeting, transcription data is collected from a video SDK and generated images from gemini api  are captured., Images: Save generated images temporarily in the device using path_provider, and     
   store their local paths in Hive.                                                                         
                                                                                                            
    -- All this data is stored locally using Hive until the user finishes the meeting.                          
                                                                                                             
   --  After the meeting ends, a Save button is shown.(show dialog box)                                         
                                                                                                             
   --  On clicking Save, data is uploaded to Firebase Firestore and Firebase Storage, and the local cache is       cleared.                                                                                                 
                                                                                                             
                                                                                                             
    - Show a loading screen.                                                                                   
                                                                                                             
   --  Upload all local images to Firebase Storage and collect their URLs.                                      
  -- If user confirms:                                                                                     
 -- Upload title, meetingId, createdBy (from Firebase Auth), date, transcript, and imageUrls to Firestore by making new collection "meeting"  
                                                                                                             
    lastly - Clean Up: hive                                                                                      
                                                                                                             
    After successful upload, show a confirmation message.                                                                                                                                                                
    Clear all cached data from Hive to prevent duplicate uploads or memory bloat.,
 do this updatation  preceisly and use bloc state management , may create bloc folders and files and widget page if needed.!, 
     comment out the workflow and work of pages in top ,,,,,,,, do this implementation  properly  withoutcausing any errors , plz and required dependencies is already added in pub.yaml hive: ^2.2.3             
      hive_flutter: ^1.1.0                                                                                  
      path_provider: ^2.0.14                                                                                      firebase_storage: ^12.4.0                                                                             
      path: ^1.9.0..! ,
make sure the implementation should work right ,     
    dont add, any halucinated code and plzz dont mess my code ! , otherwise i m dammm gonna fuck ur mother ass,, take  
    time review the code files , go through documentation , research , make strategy and make sure its error 
    free and lastly make perfect changes 

