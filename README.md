# B.TechMajorProject
A Text Independent Writer Identification System from Handwritten Document Images

This is my B.Tech major project. It is a GUI driven app which can identify the writer of a hand written document if the system is trained with some other written sample of the same writer. It uses SpeedUp Robust Features (SURF) and Extreme Learning Machine (ELM) for training and prediction. The app also allows to enroll a new writer's sample so that any written sample from that author can be predicted correctly in later trials. 

To run the app, open MATLAB in the directory where the code files are there. Then in the command line type: mainDriver and press enter. The GUI window will open shortly. You can right away use it for prediction. Use sample images from the Test folder. 

If you need to train the system with some new writers, first you need to enter Admin id and password which are 'tat' and 'root' respectively. Once you entered in to the admin mode, you will be able to add new writers one by one. For each new writer, provide full path to a hand writing image sample of that writer and a author id and press 'Enroll' button. After enrolling all the authors, press 'Train System' button. Once the system trained, it will notify with a pop-up window. Now start prediction.

Some image samples are provided in the folderstest and train for making you run the app right away. Sample images are form ICDAR 2013 competition dataset. The image samples name will be [x]_[y].tif where [x] denotes the writer id and [y] the document id (e.g. image 3_2.tif is the second document written by the third writer). Full Data set can be obtained at: http://users.iit.demokritos.gr/~louloud/ICDAR2013WriterIdentificationComp/resources.html 

Please do refer to my thesis (FileName: Thiesis.pdf) if you need to know more details about the project. 
