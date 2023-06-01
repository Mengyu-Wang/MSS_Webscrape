*** Settings ***
Documentation       Download MSS Data

Library    RPA.HTTP
Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library    RPA.FileSystem
Library    OperatingSystem
Library    DateTime

*** Tasks ***
Main
    [Documentation]    Entry point of the automation
    Set Download Directory    ${OUTPUT_DIR}
    Open Browser To Page
    Loop Through Each Year and Download

*** Keywords ***

Open Browser To Page
    Open Available Browser    http://www.weather.gov.sg/climate-historical-daily/
    Wait Until Page Contains Element    id:monthDiv

Loop Through Each Month and Download
    [Arguments]    ${year}
    ${months}=    Create List    January    February    March    April    May    June    July    August    September    October    November    December

    FOR    ${month}    IN    @{months}
        ${first_three_chars}=    Get First Three Letters    ${month}
        Wait Until Page Contains Element    id:monthDiv
        Click Element    id:monthDiv
        TRY
            Wait Until Element Is Visible    xpath://*[@id="monthDiv"]/ul/li/a[contains(text(), '${month}')]
            Wait Until Element Is Visible    xpath://*[@id="monthDiv"]/ul/li/a[contains(text(), '${month}')]
            Click Element    xpath://*[@id="monthDiv"]/ul/li/a[contains(text(), '${month}')]    #Select Month
            Wait Until Page Contains Element    xpath://*[@id="display"]
            Click Element    xpath://*[@id="display"]    #Display Button
            Wait Until Element Contains    //*[@id="temp"]/h4[1]    ${first_three_chars}
            Wait Until Page Contains Element    //*[@id="temp"]/h4[2]/p/a[1]
            Wait Until Keyword Succeeds    3x    1s    Click Element    //*[@id="temp"]/h4[2]/p/a[1]    #Download Button
        EXCEPT    
            BREAK
        END
    END

Loop Through Each Year and Download
    ${years}=    Create List    2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023
    FOR    ${year}    IN    @{years}
        Click Element    id:yearDiv
        Wait Until Element Is Visible    xpath://*[@id="yearDiv"]/ul/li/a[contains(text(), '${year}')]
        Click Element    xpath://*[@id="yearDiv"]/ul/li/a[contains(text(), '${year}')]    #Select Month

        Loop Through Each Month and Download    ${year}
    END

Get First Three Letters
    [Arguments]    ${month}
    ${first_three_chars}=    Evaluate    '${month}'[:3]
    [Return]    ${first_three_chars}