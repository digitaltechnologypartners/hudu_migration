# hudumig
hudumig is a collection of python scripts combined into a command line application using the Click Framework, designed to facilitate the migration of data from CSV files exported from ITGlue into Hudu via the Hudu API. This was built as a one-time use tool at Digital Technology Partners, but we have published it on github in the hopes that it may help someone else in the future.

Much of it is designed to be agnostic of what data is fed into it by whom, but there are a couple of programming quirks which were specific to our use-case, which will be described below.

## Major Functions
* Import CSVs exported from ITGlue to database
* Create asset layouts, companies, assets, websites, and passwords based on user defined configuration files
* Export data from hudu to json 

## Installation
1. Make sure you have python 3.11 installed.
2. Clone the repo to your working folder.
3. Create a python virtual environment in the same directory as the repo, and activate it.
4. Install requirements.txt using pip.
5. Run setup.py to install hudumig as a command within the virtual environment.

## Configuration
Hudumig requires several configuration files:
### `config.ini`
You should make a copy of `config.sample.ini`, and rename the copy to `config.ini`, then populate it with values appropriate to your needs.

Hudumig accepts variables for three databases:
* The migration database (mdb_) which is where CSV files stored in the `glue_expt_path` will be imported to, and where the application will look for data to import to hudu.
* The leftovers database, (ldb_) which is where the app will write data which is dropped from the import if `write_leftovers` is set to True
* The Connectwise Manage db (mng_) which will be used to cross reference data by certain commands if the correct switches are used.

The two `type_blacklist` variables are based on an ITGlue company type which takes the form of a comma separated string. The `type_blacklist` will exclude companies with any of the types in the list even if they have other types. The `exclusive_type_blacklist` will exclude companies which have only the given type and no other types.

### `asset_layouts.json`
* `asset_layouts.json` defines the asset layouts that will be written to hudu.
* You should review the api documentation in your hudu instance to see what options are available, and plan your assets accordingly.
* Fields of type 'AssetLink' require the "linkable_id" attribute.
   * The create_layouts.py script has a routine which looks this up for you, so this field should be filled in asset_layouts.json with the NAME of the layout you want to link.
   * Please note that a layout with an AssetLink field must come AFTER the layout that it links to in the json.
* The `common_fields` list, may contain fields that will have the same configuration values every time they are used. For instance if you want some or all of your assets to have a freeform notes fields, you could include the definition for this in the common fields list, and then you only have to identify it by name in each asset layout. See below for an example. The `asset_layouts.json` that we used for our migration is also included in the repo as an example.
* Some items that are required in the json that is sent to the api are added programmatically so there is no need to include them in your `asset_layouts.json`: (Field position, color, icon color).

#### Example `asset_layouts.json`
```
{
    "common_fields": [
        {
            "label":"Notes",
            "field_type":"RichText",
            "show_in_list":"false"
        },
        ...
    ],
    "asset_layouts": [
        {
            "name": "Location",
            "icon": "fas fa-map-marker-alt",
            "color": "#000000",
            "icon_color": "#000000",
            "fields": [
                {
                    "label": "Address",
                    "field_type": "Text",
                },
                ...
            ],
            "common_fields": [
                "Notes",
                ...
            ]
        },
        {
            ...
        }
    ]
}

```
## `.sql` files
In order for hudumig to import data to Hudu from the database containing your ITGlue export, you must provide hudumig with `.sql` files that return the data you want to import for each different type of data. Our SQL files have been included in the repo for reference.

It is important that each query return the schema that is expected by the hudu api, so using the api documentation can be helpful here. In addition, each of your asset queries, needs to correspond to an asset layout and return the same schema defined for that layout in `asset_layouts.json`.

