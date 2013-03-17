*** Settings ***

Library  Selenium2Library  run_on_failure=Capture Page Screenshot
Library  plone.app.robotframework.KeywordsLibrary
Library  plone.app.robotframework.Zope2ServerLibrary

Variables  plone/app/testing/interfaces.py
Variables  plone/app/robotframework/variables.py

*** Variables ***

${PORT} =  5000
${ZOPE_URL} =  http://localhost:${PORT}
${PLONE_URL} =  ${ZOPE_URL}/plone
${BROWSER} =  Firefox

*** Keywords ***

Start browser and wake plone up
    [Arguments]  ${ZOPE_LAYER_DOTTED_NAME}

    Start Zope Server  ${ZOPE_LAYER_DOTTED_NAME}
    Zodb setup
    Set Selenium timeout  15s
    Set Selenium implicit wait  1s

    ${previous}  Register keyword to run on failure  Close Browser
    Wait until keyword succeeds  2min  3s  Access plone
    Register keyword to run on failure  ${previous}

Access plone
    Open browser  ${ZOPE_URL}  ${BROWSER}
    Goto homepage
    [Return]  True

Close browser, teardown zodb, and stop selenium server
    Close browser
    Zodb teardown
    Stop Zope Server
