# 加载必要的库
library(dplyr)

# 读取特征名和活动标签
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt", col.names = c("class", "activity_name"))
read_data <- function(type) {
  x <- read.table(paste0("X_", type, ".txt"), header = FALSE)
  y <- read.table(paste0("y_", type, ".txt"), header = FALSE)
  subject <- read.table(paste0("subject_", type, ".txt"), header = FALSE)
  data <- cbind(subject, y, x)
  colnames(data) <- c("subject", "activity", as.character(features$V2))
  return(data)
}

# 读取训练和测试数据
data_train <- read_data("train")
data_test <- read_data("test")

# 合并数据集
data_combined <- rbind(data_train, data_test)

# 提取含有 mean() 和 std() 的列
data_mean_std <- select(data_combined, contains("mean"), contains("std"), "subject", "activity")

# 添加活动名称
data_mean_std <- merge(data_mean_std, activity_labels, by.x = "activity", by.y = "class")

# 创建整洁数据集
tidy_data <- data_mean_std %>%
  group_by(subject, activity_name) %>%
  summarise_all(funs(mean))

# 保存数据集
write.table(tidy_data, "tidy_dataset.txt", row.names = FALSE)

