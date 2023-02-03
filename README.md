# hudu_migration
Scripts and resources related to DTP migration from ITGlue to Hudu - 2023

## Dev environment setup
* populate .env accordingly
* Create venv
* activate venv 
* install requirements.txt

## Hello world
* Basic script which gets the 'api_info' endpoint and prints the text to the console
* demonstrates basic usage/authentication of the hudu api in python

## Asset_layouts.json
* json file which defines the asset layouts that will be written to hudu
* see documentation for available options: https://hudu.dtpartners.com/developer/1.0/asset_layouts/create.html
* fields of type 'AssetLink' require the "linkable_id" attribute.
   * The documentation says this should be an integer however it must match the id of the record in the database
   * The create_layouts.py script has a routine which looks this up for you, so this field should be filled in asset_layouts.json with the NAME of the layout you want to link.
   * Please note that a layout with an AssetLink field must come AFTER the layout that it links to in the json.

### Minimum acceptable fields for an asset layout entry
```
[
    {
        "name": "Location",
        "icon": "fas fa-map-marker-alt",
        "color": "#000000",
        "icon_color": "#000000",
        "fields": [
            {
                "label": "Address",
                "field_type": "Text",
                "position": 1   <--- This is not marked as req'd in the documentation but it doesn't work without it
            }
        ]
    },
    {
        ...
    }
]

```