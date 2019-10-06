module Main exposing (main)

import Browser
import Element exposing (Element, centerX, column, el, fill, layout, text, width)
import Element.Border as Border
import Html exposing (Html)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    String


init : () -> ( Model, Cmd Msg )
init _ =
    ( ""
    , Cmd.none
    )



-- Msg


type Msg
    = Temp



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    layout
        [ width fill
        ]
    <|
        column
            [ width fill
            ]
            [ viewTitle
            , viewLogo
            , viewDescription
            , viewSearchButton
            , viewSearchResult
            , viewFooter
            ]


viewTitle : Element Msg
viewTitle =
    el
        [ width fill
        , Border.width 1
        ]
    <|
        el [ centerX ] <|
            text "Title"


viewLogo : Element Msg
viewLogo =
    el
        [ width fill
        , Border.width 1
        ]
    <|
        el
            [ centerX ]
        <|
            text "Logo"


viewDescription : Element Msg
viewDescription =
    el
        [ width fill
        , Border.width 1
        ]
    <|
        el [ centerX ] <|
            text "Description"


viewSearchButton : Element Msg
viewSearchButton =
    el
        [ width fill
        , Border.width 1
        ]
    <|
        el [ centerX ] <|
            text "Searching Button"


viewSearchResult : Element Msg
viewSearchResult =
    el
        [ width fill
        , Border.width 1
        ]
    <|
        el [ centerX ] <|
            text "Search Result"


viewFooter : Element Msg
viewFooter =
    el
        [ width fill
        , Border.width 1
        ]
    <|
        el [ centerX ] <|
            text "Footer"
