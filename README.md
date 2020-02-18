# Prediction Activity

A mini-prediction competition. Who can produce the best model to predict pass/fail

### Download
* Download the Open University Learning Analytics dataset from [here](https://analyse.kmi.open.ac.uk/open_dataset)
* Import the `studentVle.csv`, `studentAssessment.csv` and `studentInfo.csv` files into R
```{r}
a1 <- read.csv("studentVle.csv")
b1 <- read.csv("studentAssessment.csv")
c1 <- read.csv("studentInfo.csv")
```
### Wrangling
* Calculate the average daily number of clicks (site interactions) for each student from the `studentVle` dataset
```{r}
library(tidyr)
library(dplyr)
avg <- select(a1, "id_student", "date", "sum_click")
avg <- arrange(avg, id_student)
daily_N <- round(aggregate(avg[, 3], list(avg$id_student), mean),2)
```
* Calculate the average assessment score for each student from the `studentAssessment` dataset
```{r}
score_avg <- select(b1, "id_student", "score")
score_avg <- arrange(score_avg, id_student)
score_N <- round(aggregate(score_avg[, 2], list(score_avg$id_student), mean),2)
```
* Merge your click and assessment score average values into the the `studentInfo` dataset
```{r}
names(daily_N) <- c("id","click_avg")
m1 <- merge(c1, daily_N, by.x="id_student", by.y = "id")
names(score_N) <- c("id","score_avg")
m1 <- merge(m1, score_N, by.x="id_student", by.y = "id")
```
### Create a Validation Set
* Split your data into two new datasets, `TRAINING` and `TEST`, by **randomly** selecting 25% of the students for the `TEST` set
```{r}
library(caret) 
index <- createDataPartition(
  y = m1$final_result,
  p = .75,
  list = FALSE)
train_set <- m1[index,]
test_set <- m1[-index,]
```

### Explore
* Generate summary statistics for the variable `final_result`
```{r}
table(m1$final_result)
anyNA(m1$final_result)
```
* Ensure that the final_result variable is binary (Remove all students who withdrew from a courses and convert all students who recieved distinctions to pass)
```{r}
m1 <- m1 %>% filter(final_result!= "Withdrawn")
m1$final_result <- ifelse(m1$final_result == "fail", "fail", "pass")
```
* Visualize the distributions of each of the variables for insight
* Visualize relationships between variables for insight


### Model Training
* Install the `caret` package
* You will be allocated one of the following models to test:

  CART (`RPART`), Conditional Inference Trees (`party`), Naive Bayes (`naivebayes`), Logistic Regression (`gpls`)

* Using the `trainControl` command in the `caret` package create a 10-fold cross-validation harness:   
  `control <- trainControl(method="cv", number=10)`
* Using the standard caret syntax fit your model and measure accuracy:  
```{r}
fit <- train(final_result~., data=train_set, method= "party", metric="accuracy", trControl=control)
```
* Generate a summary of your results and create a visualization of the accuracy scores for your ten trials
* Make any tweaks to your model to try to improve its performance


### Model Testing
* Use the `predict` function to test your model  
  `predictions <- predict(fit, TEST)`
* Generate a confusion matrix for your model test  
  `confusionMatrix(predictions, TEST$final_result)`
