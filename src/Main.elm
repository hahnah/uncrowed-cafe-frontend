port module Main exposing (main)

import Browser
import Element exposing (Element, centerX, centerY, column, el, fill, height, layout, padding, row, text, width, wrappedRow)
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)



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
    { location : Maybe Location }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { location = Nothing }
    , Cmd.none
    )


type alias Location =
    { latitude : Float
    , longitude : Float
    }



-- Msg


type Msg
    = ClickSearchButton
    | GetLocation String



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveLocation GetLocation


port receiveLocation : (String -> msg) -> Sub msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickSearchButton ->
            ( model, requestLocation () )

        GetLocation jsonString ->
            let
                decodedLocation : Result Decode.Error Location
                decodedLocation =
                    Decode.decodeString locationDecoder jsonString

                maybeLocation : Maybe Location
                maybeLocation =
                    case decodedLocation of
                        Ok location_ ->
                            Just location_

                        Err _ ->
                            Nothing
            in
            ( { model | location = maybeLocation }, Cmd.none )


port requestLocation : () -> Cmd msg


locationDecoder : Decoder Location
locationDecoder =
    Decode.map2 Location
        (Decode.at [ "location", "latitude" ] Decode.float)
        (Decode.at [ "location", "longitude" ] Decode.float)



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
            [ el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewTitle
            , el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewLogo
            , el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewDescription
            , el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewSearchButton
            , el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewSearchResult
            , el
                [ width fill
                , centerX
                , centerY
                , padding 4
                , Border.width 1
                ]
                viewFooter
            ]


viewTitle : Element Msg
viewTitle =
    el [ centerX ] <|
        text "Title"


viewLogo : Element Msg
viewLogo =
    el
        [ centerX ]
    <|
        text "Logo"


viewDescription : Element Msg
viewDescription =
    el [ centerX ] <|
        text "Description"


viewSearchButton : Element Msg
viewSearchButton =
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
        [ el [ padding 10 ] viewCafe
        , el [ padding 10 ] viewCafe
        , el [ padding 10 ] viewCafe
        , el [ padding 10 ] viewCafe
        , el [ padding 10 ] viewCafe
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
    el [ centerX ] <|
        text "Footer"
