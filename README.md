# hudu_migration
Scripts and resources related to DTP migration from ITGlue to Hudu - 2023

## Dev environment setup
* populate .env accordingly
* Create venv
* activate venv 
* install requirements.txt

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

## hudu_migrator.py
This is the main program. It runs as a console application. From the context of the parent folder containing it, run `python hudu_migrator.py`. You will then be greeted with a prompt to enter a command. Type `help` to see available commands. It can be ended with `quit`, `stop`, `exit` or `ctrl-c`. Currently it contains functions to load the export glue export db, create asset layouts based on asset_layouts.json and create companies. There is no custom error handling or logging at this time.

## .env
The env file must be populated appropriately before any of the commands can be run.
```
API_KEY = "apikey"
BASE_URL = "https://[our domain].com/api/v1/"
DB_CON_STR = "mysql+pymysql://username:password@localhost:3306/dbname?charset=utf8mb4"
GLUE_EXPT_PATH = "./path/to/export"
```