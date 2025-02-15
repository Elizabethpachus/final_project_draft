library(readr)
library(markdown)
library(shiny)
library(tidyverse)


# If you run these lines of code, then the read_rds works and can read the data into a local variabel

final_data_map_app <- read_rds("project_shiny/final_data_map.rds")

final_data_suicide_app <- read_rds("project_shiny/final_data_suicide.rds")

# However when you run the app, they cause it to crash because the directory is unavaliable

# These lines of code below shoud work, but they don't for some reason 

final_data_map_app <- read_rds("final_data_map.rds")

final_data_suicide_app <- read_rds("final_data_suicide.rds")

# Define UI for application that displays my graph
ui <- fluidPage(
    
    # Application title
    titlePanel("Guns in America"),
    
    navbarPage("Navbar",
               
               # First panel on website
               
               tabPanel("Firearm Death Rate",
                        plotOutput("firearm_plot"),
                        selectInput(inputId = "year", 
                                    label = "Select Year", 
                                    choices = c("2017" = 2017, "2016" = 2016, "2015" = 2015, "2014" = 2014, "2005" = 2005), selected = "a"),
                        
               ),
               
               # Second panel on website
               
               tabPanel("Suicide Rate and Deaths by Guns",
                        selectInput(inputId = "year2",  # Give the input a name "genotype"
                                    label = "Select Year",  # Give the input a label to be displayed in the app
                                    choices = c("2017" = 2017, "2016" = 2016, "2015" = 2015, "2014" = 2014, "2005" = 2005), selected = "a"),
                        plotOutput("suicide_plot")
               ),
               
               # Including the About page info here
               
               tabPanel("About",
                        includeMarkdown("about.md")
               )
    )
)



# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
    # Creating the map graphic on the home page
    
    output$firearm_plot <- renderPlot(ggplot(data = final_data_map_app[final_data_map_app$year == input$year,],
                                             mapping = aes(x = long, y = lat, group = group, fill = rate_per_1000)) + 
                                          geom_polygon(color = "gray90", size = 0.1) +
                                          coord_map(projection = "albers", 
                                                    lat0 = 39, lat1 = 45) + 
                                          labs(title = "Firearm Mortality by State") + 
                                          theme_map() + 
                                          labs(fill = "Death Rate per 100,000") + 
                                          scale_fill_gradient(low = "#ffcccb", 
                                                              high = "#CB454A") +
                                          labs(title = "Firearm Mortality by State",
                                               subtitle = "Firearm Death Rate Per 1000 People",
                                               caption = "Data from CDC") +
                                          theme(legend.position = "right",
                                                plot.title = element_text(hjust = 0.5))
    )
    
    # Creating a graph trying to find the correlation between suicides and gun deaths per year
    
    output$suicide_plot <- renderPlot(ggplot(data = final_data_suicide_app[final_data_suicide_app$year == input$year2,], aes(x = suicide_rate, y = deaths_year)) +
                                          geom_point() +
                                          geom_smooth(method = "lm") +
                                          labs(
                                              title = "Deaths per Year by Guns by Suicide Rate of State",
                                              x = "Suicide Rate per 1000",
                                              y = "Deaths per Year"
                                          ) +
                                          theme_gdocs(base_size = 12, base_family = "sans")
                                      
                                      
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
