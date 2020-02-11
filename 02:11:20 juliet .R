#Import the studentVle.csv, studentAssessment.csv and studentInfo.csv files into R

studentvle = read.csv("studentVle.csv")

studentAssessment = read.csv("studentAssessment.csv")

studentInfo = read.csv("studentInfo.csv")

(average_clicks = mean(studentvle$sum_click))

#average assessment score for each student from th

new_student_Ass = na.omit(studentAssessment)

mean(new_student_Ass$score)

data = cbind(studentInfo,average_clicks, 75.79957)

