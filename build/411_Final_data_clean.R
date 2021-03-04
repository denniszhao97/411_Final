# Load header file: -------------------------------------------------------
rm(list = ls())  #clear Environment
header <- new.env() #create new Environment
# assume you stored the git cloned repository in a folder called github, which is at your home address.
# will load everything in header.R first
source("~/github/411_Final/build/header.R", local = header) 

# Code: -------------------------------------------------------------------

# helper functions:

# all_types = c() #get all possible bullet type
# for (input_string in gun_data$participant_relationship){
#   splitted_string = strsplit(input_string, "||",fixed=TRUE)[[1]]
#   for (string in splitted_string){
#     cur_type = tail(strsplit(string, ":")[[1]],1)
#       if (cur_type %in% all_types){
#         next
#       } else {
#         all_types = c(all_types,cur_type)
#       }
#     }
# }

calculate_gun_source <- function(input_string){
  count = 0
  if (!is.na(input_string)){
    splitted_string = strsplit(input_string, "||",fixed=TRUE)[[1]]
    stolen_true = 0
    unknown_true = 0
    nonstolen_true = 0
    result = ""
    for (string in splitted_string){
      if(tail(strsplit(string, ":")[[1]],1) == "Stolen" & stolen_true == 0){
        result = paste0(result, "Stolen ")
        stolen_true = 1
      }
      if(tail(strsplit(string, ":")[[1]],1) == "Unknown" & unknown_true == 0){
        result = paste0(result, "Unknown ")
        unknown_true = 1
      }
      if(tail(strsplit(string, ":")[[1]],1) == "Not-stolen" & nonstolen_true == 0){
        result = paste0(result, "Not-stolen ")
        nonstolen_true = 1
      }
    }
  }
  return(result)
}  


calculate_gun_type <- function(input_string){
  count = 0
  handgun = c("Handgun","9mm","40 SW","44 Mag","38 Spl","45 Auto","380 Auto","32 Auto","357 Mag","25 Auto","10mm")
  rifle = c("22 LR","223 Rem [AR-15]","7.62 [AK-47]","308 Win","Rifle","30-30 Win","30-06 Spr","300 Win")
  shortgun = c("Shotgun","12 gauge","410 gauge","16 gauge","20 gauge","28 gauge" )
  if (!is.na(input_string)){
    splitted_string = strsplit(input_string, "||",fixed=TRUE)[[1]]
    handgun_true = 0
    rifle_true = 0
    shortgun_true = 0
    result = ""
    for (string in splitted_string){
      if(tail(strsplit(string, ":")[[1]],1) %in% handgun & handgun_true == 0){
        result = paste0(result, "Handgun ")
        handgun_true = 1
      }
      if(tail(strsplit(string, ":")[[1]],1) %in% rifle & rifle_true == 0){
        result = paste0(result, "Rifle ")
        rifle_true = 1
      }
      if(tail(strsplit(string, ":")[[1]],1) %in% shortgun & shortgun_true == 0){
        result = paste0(result, "Shortgun ")
        shortgun_true = 1
      }
    }
  }
  return(result)
}  

extract_relationship <- function(input_string){
  result = ""
  if (!is.na(input_string)){
    splitted_string = strsplit(input_string, "||",fixed=TRUE)[[1]]
    for (string in splitted_string){
      cur = tail(strsplit(string, ":")[[1]],1)
      if (cur %in% result){
        next
      } else {
        result = paste0(result, cur, " ")
      }
    }
  }
  if(result == ""){
    result = "Unknown"
  }
  return(result)
}  

extract_shooter_info <- function(type_string, info_string){
  result = 0
  if (!is.na(input_string) & !is.na(info_string)){
    id = -1
    splitted_string = strsplit(type_string, "||",fixed=TRUE)[[1]]
    for (string in splitted_string){
      cur = strsplit(string, ":")[[1]]
      if (tail(cur,1) == "Subject-Suspect"){
        id = head(cur,1)
        break
      }
    }
    if(id != -1){
      splitted_string = strsplit(info_string, "||",fixed=TRUE)[[1]]
      for (string in splitted_string){
        cur = strsplit(string, ":")[[1]]
        if (head(cur,1) == id){
          result = tail(cur,1)
        }
      }
    }
  }
  if(result == 0){
    result = "Unknown"
  }
  return(result)
}
calculate_gun_number <- function(input_string){
  if (!is.na(input_string)){
    splitted_string = strsplit(input_string, "||",fixed=TRUE)[[1]]
    return(length(splitted_string))
  }
}  

# Main Code: -------------------------------------------------------------------

# Import raw dataset
gun_data = read_csv(header$dataset('gun_data_13_18.csv'))
relavent_columns = c("date","state","city_or_county","n_killed","n_injured","gun_stolen",
                     "gun_type","incident_characteristics","latitude","longitude", "notes",
                     "participant_age","participant_gender","participant_name","participant_relationship",
                     "participant_status","participant_type")
gun_data = gun_data %>% 
  select(all_of(relavent_columns)) %>% 
  drop_na(-c("notes","participant_relationship","participant_name"))


# may consider this is tableau cannot handle large dataset
#gun_data = gun_data %>% drop_na(-c("notes","participant_relationship","participant_name"))

# use sapply because column is a vector          
gun_data$gun_source = sapply(gun_data$gun_stolen,calculate_gun_source)
gun_data$guns_involved = sapply(gun_data$gun_stolen,calculate_gun_number)
gun_data$gun_types = sapply(gun_data$gun_type,calculate_gun_type)
gun_data$relationship = sapply(gun_data$participant_relationship, extract_relationship)

#use mapply because we use multiple columns as input
gun_data$shooter_age = mapply(extract_shooter_info,gun_data$participant_type, gun_data$participant_age)
gun_data$shooter_gender = mapply(extract_shooter_info,gun_data$participant_type, gun_data$participant_gender)
gun_data$shooter_name = mapply(extract_shooter_info,gun_data$participant_type, gun_data$participant_name)
gun_data$shooter_status = mapply(extract_shooter_info,gun_data$participant_type, gun_data$participant_status)

# delete cleaned columns
gun_data = gun_data %>% select(-c("gun_stolen","gun_type","participant_age","participant_gender",
                                  "participant_name","participant_relationship","participant_status",
                                  "participant_type"))
output_path = header$dataset("cleaned_gun_data.csv")
write_csv(gun_data,output_path)
