module Main exposing (main)

import Browser
import Element exposing (Element, centerX, centerY, column, el, fill, height, layout, row, text, width, wrappedRow)
import Element.Border as Border
import Element.Input as Input
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
    = ClickSearchButton



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
            , centerX
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
            Input.button
                [ Border.width 1
                , Border.rounded 15
                , Element.paddingXY 10 4
                ]
                { onPress = Just ClickSearchButton
                , label = text "Search Cafes Near You"
                }


viewSearchResult : Element Msg
viewSearchResult =
    wrappedRow
        []
        [ viewCafe
        , viewCafe
        , viewCafe
        , viewCafe
        , viewCafe
        ]


viewCafe : Element Msg
viewCafe =
    row
        [ Border.width 1 ]
        [ text "Thumbnail"
        , column
            []
            [ el [] <| text "Sample Cafe"
            , el [] <| text "Congestion Rate : 50%"
            , el [] <| text "Stars : ★★★★☆"
            , el [] <| text "Distance : 100M"
            , el [] <| text "View On Google Map"
            ]
        ]


viewFooter : Element Msg
viewFooter =
    el
        [ width fill
        , Border.width 1
        ]
    <|
        el [ centerX ] <|
            text "Footer"
