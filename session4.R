# Load Required Packages --------------------------------------------------
library(plotly)
library(dplyr)

# Load Data From the Web --------------------------------------------------
# Note: No guarantee that the data source is reliable. :|
file_url <- "https://raw.githubusercontent.com/datasets/gdp/master/data/gdp.csv"
gdp_data <- read.csv(url(file_url))
# Save Data to your computer, not really necessary
download.file(file_url, destfile = "gdp_data.csv")

# Adding Decade Variable --------------------------------------------------
# Add a decade variable
gdp_data$decade <- gdp_data$Year - (gdp_data$Year %% 10)
class(gdp_data$decade[0])
gdp_data$decade <- as.factor(gdp_data$decade)

# Subset Data into Regions ------------------------------------------------
# German GDP, 3 ways how to do it 
german_gdp <- gdp_data[gdp_data$Country.Name == 'Germany', ]
german_gdp <- subset(gdp_data, Country.Name == 'Germany')
german_gdp <- filter(gdp_data, Country.Name == 'Germany')

# Indian GDP
indian_gdp <- subset(gdp_data, Country.Name == 'India' & Year >= 1970)

# Example PLOTLY Line Plot ------------------------------------------------
# Plot Line Plot India vs. Germany 
gdp_plot <- plot_ly(german_gdp, x = ~Year, 
                                y = ~Value, 
                                name='Germany', 
                                type = 'scatter', 
                                mode = 'lines')
gdp_plot <- gdp_plot %>% add_trace(y = indian_gdp$Value, name='India', type='scatter', mode='lines')
gdp_plot

gdp_plot <- gdp_plot %>% layout(title = "Total GDP in USD over Years",
                                xaxis = list(title = "Years"),
                                yaxis = list (title = "Total GDP in Trillion USD"))
gdp_plot

# Example Aggregating over Decades ----------------------------------------
# Aggregate over decades within the Euro Area
euro_gdp <- subset(gdp_data, Country.Code == 'EMU')
euro_gdp_decade <- tapply(euro_gdp$Value, euro_gdp$decade, mean) 
euro_gdp_decade <- data.frame(euro_gdp_decade)

# Aggregate over decades World Wide
wld_gdp <- subset(gdp_data, Country.Code == 'WLD')
wld_gdp_decade <- tapply(wld_gdp$Value, wld_gdp$decade, mean)
wld_gdp_decade <- data.frame(wld_gdp_decade) 

# Example PLOTLY Bar Plot -------------------------------------------------
# Create a Bar Plot
eu_plot <-  plot_ly(euro_gdp_decade, 
                    x = row.names(euro_gdp_decade), 
                    y = ~euro_gdp_decade , 
                    name='EU Zone' , 
                    type = 'bar' )
eu_plot <- eu_plot %>% layout(title = "Average GDP in USD per Decade in Euro Area",
                              xaxis = list(title = "Decade"),
                              yaxis = list (title = "Average GDP in Trillion USD"))
eu_plot

# Add another bar to the plot
cmp_plot <- plot_ly(euro_gdp_decade, 
                    x = row.names(euro_gdp_decade), 
                    y = ~euro_gdp_decade , 
                    name='EU Zone' , 
                    type = 'bar' ) %>% 
            add_trace(x = row.names(wld_gdp_decade), 
                      y = wld_gdp_decade$wld_gdp_decade, 
                      name = 'WORLD',
                      type='bar') %>% 
            layout(title = "Average GDP in USD per Decade World vs. Europe",
                   xaxis = list(title = "Decade"),
                   yaxis = list (title = "Average GDP in Trillion USD"),
                   barmode='group')
cmp_plot

# Session Info for Reproducibilty -----------------------------------------
# Print Session Info so that your colleague knows which package version are required
sessionInfo()

# If you only want to know a specific package version
packageVersion("plotly")
