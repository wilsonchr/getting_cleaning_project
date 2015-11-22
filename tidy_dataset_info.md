# tidy_dataset.txt Codebook

The dataset contained here is an adjusted dataset based on the 
requirements of the getting and cleaning data project.  

##Each record in the dataset contains:
- volunteer_id: The ID of the volunteer
- activity: The activity performed (LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS)
The remainer of the fields are the average of the original variable in the original dataset.  
The variable name is prefaced with "average" to denote this.  Only the "mean" and "std" variables were selected from the
original dataset. The variables are named according to the following standard:
  average_[t/f]_[variableName]_[mean/std]_[X,Y,Z]
  where: 
   - [t/f] designates either the time (t) or frequency (f) domain
   - [variableName] designates the variable name from the original dataset
   - [mean/std] designates the mean or standard deviation variable from the original dataset
   - [X,Y,Z] designates with axis the measurement is taken


