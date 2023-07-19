# hudumig
hudumig is a collection of python scripts combined into a command line application using the Click Framework, designed to facilitate the migration of data from CSV files exported from ITGlue into Hudu via the Hudu API. This was built as a one-time use tool at Digital Technology Partners, but we have published it on github in the hopes that it may help someone else in the future.

## Major Functions
* Import CSVs exported from ITGlue to database
* Create asset layouts, companies, assets, websites, and passwords based on user defined configuration files
* Export data from hudu to json 

## Installation
1. Make sure you have python 3.11 installed.
2. Clone the repo to your working folder on your migration host.
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
### `.sql` files
In order for hudumig to import data to Hudu from the database containing your ITGlue export, you must provide hudumig with `.sql` files that return the data you want to import for each different type of data. Our SQL files have been included in the repo for reference. 

It is important that each query return the schema that is expected by the hudu api, so using the api documentation can be helpful here. In addition, each of your asset queries, needs to correspond to an asset layout and return the same schema defined for that layout in `asset_layouts.json`.

* Assets and passwords additionally require the record id of the item from ITGlue to be passed as `glue_id` in order to link passwords to their parent assets.
* If you pass the 'archived' field from glue in the json for an asset it will be placed in the hudu museum.

## Logging
Hudumig can log lots of data in order to provide information for troubleshooting. Specify your logging settings in config.ini:
* `log_level`: Set based on standard python log levels. Hudumig will write 'INFO', 'WARNING', and 'ERROR' logs.
* `default_log_file`: Specify the file name and path for the log file.
* `verbose_logs`: True or False. When set to false, logs will each be a single line. When set to true, will include stack trace information and api input and output data.

## Cross Referencing Companies
The companies command is capable of pulling data from both the ITGlue export database, and from the connectwise Manage database, and cross referencing them to get data not present in the other one.
* You can use glue as a source (which is the default) and if you wish, cross reference it with manage to get a company's primary website.
* You can specifiy manage as the source, and if you wish cross reference it with glue to get the Company Alerts and Quick Notes fields.

## Other Items (unique to our company)
### Assets
* Expects a 'Location' asset type, and to have locations as the first asset written.
* Will lookup and parse connected locations when an AssetTag field called 'Location' is included in other assets, and the name of the location is passed. This code could easily be repurposed to do the same for any AssetTag field.
* If you pass the json for 'Interfaces' found in ITGLue configuration to a RichText field called 'Interfaces' it will parse the json data into an html table.
### Passwords
* Will not link passwords to assets with a type named 'Location'.
* If you have an AssetLayout called 'Office365 tenant', it will link any passwords with name containing the string '365' or a username containing 'onmicrosoft.com' to the Office365 tenant for the given company record.

## The Commands
The main command is `hudumig`. Each function of the app is executed by running subcommands of `hudumig`, and each subcommand has a few switches which control what action it takes and how it works. 

You can execute any command with `--help` to see the associated help file.

|Command|Switch|Description|
|---|---|---|
|config|-c|Modify varibles in the configuration file.|
||-l|Load the export DB with CSVs found in the ITGlue export folder.|
||-d|Declare the path in which to look for the export files. Default is set in config.ini.|
|layouts|-c|Create asset layouts from asset_layouts.json.|
||-o|Output existing layouts to json. Occurs after creation if executed simultaneously.|
||-l|Declare json file containing asset layouts. Defaults is set in config.ini|
||-f|Declare file output command should write to. Defaults is set in config.ini|
|companies|-c|Create companies from specified source DB based on supplied query.|
||-s|Specify the source db as either 'glue' or 'manage'. Defaults to 'glue'|
||-x|If using glue as source, cross reference with manage to pull primary website. If using manage as source, cross reference with glue to pull Company Alerts and Quick notes.|
||-o|Output existing companies to json. Occurs after creation if executed simultaneously.|
||-q|Specify a .sql file from which to pull companies. Default set in config.ini|
||-f|Specify a .json file to output existing companies to. Default set in config.ini|
|assets|-c|Create assets for specified assettype argument. Must specify query file.|
||-o|Output existing assets for specified assettype argument to json. Must specify file name. Occurs after creation if executed simultaneously.|
|websites|-c|Create websites based on specified query.|
||-o|Output existing websites in json to specified output file. Occurs after creation if executed simultaneously.|
||-q|Specify a .sql file from which to pull websites. Default set in config.ini.|
||-f|Specify a .json file to output existing websites to. Default set in config.ini.|
|passwords|-c|Create passwords based on specified query.|
||-o|Output existing passwords in json to specified output file. Occurs after creation if executed simultaneously.|
||-q|Specify a .sql file from which to pull passwords. Default set in config.ini.|
||-f|Specify a .json file to output existing passwords to. Default set in config.ini.|


### Examples
* Write layouts using default layouts file:  
`hudumig layouts -c`  
* Output layouts to non default output file:  
`hudumig layouts -of /path/layouts.json`  
* Write companies from glue, but pull extra data from manage:  
`hudumig companies -cx`  
* Write companies from manage:  
`hudumig companies -c -s manage`  
* Create assets for Location asset type:  
`hudumig assets -c locations.sql Location`
* Create assets for Software asset type:    
`hudumig assets -c applications.sql Software`  
* Create passwords using non default passwords query:  
`hudumig passwords -cq /path/somepws.sql`  

### Command chaining:
Commands may be chained as below and will be executed synchronously in the order they are written. This is useful as you can create a script to provide a shorthand for executing the commands specific to your migration.

```
hudumig layouts -c companies -cx websites -c assets -c locations.sql Location passwords -c
```

### Order of Operations
You should carefully consider how you order your commands, especially where they rely on data already existing in hudu. You should run asset layouts first, then companies, then websites, then all assets, and finally passwords last. The order in which individual assets are run may also be important depending on how you have set up your migration.
