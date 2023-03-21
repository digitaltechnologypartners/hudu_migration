import click
import logging
from hudumig.utils import getExistingRecords, writeJson, stackLog
from hudumig.settings import ASSET_LAYOUTS_JSON,ASSET_LAYOUTS_OUTPUT,COMPANIES_OUTPUT,COMPANIES_QUERY,GLUE_EXPT_PATH,CONFIG_PATH,OUTPUT_PATH,SQL_PATH
from hudumig.cmdmods.layouts import createlayouts
from hudumig.cmdmods.companies import createCompanies
from hudumig.cmdmods.assets import createAssets,getAssetLayoutAndID
from hudumig.cmdmods.config import loadExpDb,updateConfigVars

logger = logging.getLogger(__name__)
logging.basicConfig(filename='hudumig.log', filemode='a', level=logging.INFO, format='%(asctime)s : %(levelname)s : %(message)s ', datefmt='%m/%d/%Y %I:%M:%S %p')

@click.group("cli",chain=True)
def cli():
    pass

@cli.command()
@click.option('-c','--configvar',nargs=2,type=str,multiple=True,help='Modify varibles in the configuration file.')
@click.option('-l','--loadexpdb',is_flag=True,help='Load the export DB with CSVs found in the ITGlue export folder.')
@click.option('-d','--expdbpath',default=GLUE_EXPT_PATH,show_default=True,help='Declare the path in which to look for the export files.')
def config(configvar,loadexpdb,expdbpath):
    """Configure various aspects of hudumig."""
    if loadexpdb:
        try:
            loadExpDb(expdbpath)
        except Exception as e:
            stackLog(e,'load export db')
            click.echo('Got an error attempting to load the export database. Check the logs.')
    if configvar:
        try:
            updateConfigVars(configvar)
        except Exception as e:
            stackLog(e,'update config variables')
            click.echo('Got an error attempting to update config variables. Check the logs.')
    if not loadexpdb and not configvar:
        click.echo('No option was selected. Enter "hudumig config --help" to see available options.')

@cli.command()
@click.option('-c','--create', is_flag=True, help='Create asset layouts from [LAYOUTSJSON].')
@click.option('-o','--output', is_flag=True, help='Output existing layouts in Json to [OUTPUTFILE] (occurs after creation if called in same command).')
@click.option('-l','--layoutsjson', default=ASSET_LAYOUTS_JSON, show_default=True, help='Declare file from which to read layouts to write to hudu.')
@click.option('-f','--outputfile', default=ASSET_LAYOUTS_OUTPUT, show_default=True, help='Declare file to output existing layouts to.')
def layouts(create,output,layoutsjson,outputfile):
    """Create asset layouts and/or output existing layouts to a json file."""
    endpoint='asset_layouts'
    if create:
        try:
            createlayouts(layoutsjson)
            click.echo('Created layouts from ' + layoutsjson)
        except Exception as e:
            stackLog(e,'create layouts')
            click.echo('Got an error attempting to create layouts. Check the logs.')
    else:
        click.echo('Nothing was created.')
    if output:
        try:
            layouts = getExistingRecords(endpoint)
            writeJson(layouts,outputfile)
            click.echo('Existing layouts exported to ' + outputfile)
        except Exception as e:
            stackLog(e,'output layouts')
            click.echo('Got an error attempting to output layouts. Check the logs.')
        
    if not output and not create:
        click.echo('No option was selected. Enter "hudumig layouts --help" to see available options.')

@cli.command()
@click.option('-c','--create', is_flag=True, help='Create companies from specified source db based on --query')
@click.option('-s','--source', default='glue', type=click.Choice(['glue','manage'],case_sensitive=False), show_default=True, help='Declare the source database from which created companies should be pulled')
@click.option('-x','--xref', is_flag=True, help='If using glue as source, cross reference with manage to pull primary website. If using manage as source, cross reference with glue to pull Company Alerts and Quick notes.')
@click.option('-o','--output', is_flag=True, help='Output existing companies in Json to --outputfile (occurs after creation if called in same command)')
@click.option('-q','--query', default=COMPANIES_QUERY, show_default=True, help='Declare file containing query to use to pull companies from database')
@click.option('-f','--outputfile', default=COMPANIES_OUTPUT, show_default=True, help='Declare file to output existing companies to')
def companies(create,source,xref,output,query,outputfile):
    """Create companies and/or output existing companies to a json file.
    
    Note that alerts, and quick notes from glue will be concatenated into hudu notes field."""
    endpoint='companies'
    if create:
        try:
            createCompanies(source,query,xref)
        except Exception as e:
            stackLog(e,'create companies')
            click.echo('Got an error attempting to create companies. Check the logs.')
    else:
        click.echo('Nothing was created.')
    if output:
        try:
            companies = getExistingRecords(endpoint)
            writeJson(companies,outputfile)
            click.echo('Existing companies exported to' + outputfile)
        except Exception as e:
            stackLog(e,'output companies')
            click.echo('Got an error attempting to output companies. Check the logs.')
    if not output and not create:
        click.echo('No option was selected. Enter "hudumig companies --help" to see available options.')

@cli.command()
@click.option('-c','--create', help='Create assets for specified ASSETTYPE')
@click.option('-o','--output', help='Output existing assets for specified ASSETTYPE in Json to specified output file (occurs after creation if called in same command)')
@click.argument('assettype')
def assets(create,output,assettype):
    """Create assets for specified ASSETTYPE based on sql file passed as argument to --create, and/or output exsiting assets for specified ASSETTYPE to a json file passed as argument to --output
    
    You must specify the Asset Type you wish to work with by exact case sensitive name as it appears in Hudu.
    
    You must also specify the query file each time you use the --create option, and the output file each time you use the --output option."""
    assetLayoutId,layout = getAssetLayoutAndID(assettype)
    if assetLayoutId == None:
        click.echo('Asset Type ' + assettype + ' not found.')
    else:
        if create:
            try:
                create = SQL_PATH + create
                createAssets(assetLayoutId,layout,assettype,create)
            except Exception as e:
                stackLog(e,'create ' + assettype + ' assets')
                click.echo('Got an error attempting to create ' + assettype + ' assets. Check the logs.')
        if output:
            try:
                output = OUTPUT_PATH + output
                endpoint = 'assets?asset_layout_id=' + str(assetLayoutId) + '&'
                assets = getExistingRecords(endpoint)
                writeJson(assets,output)
                click.echo('Existing assets of type ' + assettype + ' exported to ' + output)
            except Exception as e:
                stackLog(e,'output ' + assettype + ' assets')
                click.echo('Got an error attempting to output ' + assettype + ' assets . Check the logs.')
        if not output and not create:
            click.echo('No option was selected. Enter "hudumig assets --help" to see available options.')

@cli.command()
def domains():
    click.echo('Domains functionality not yet created.')

@cli.command()
def passwords():
    click.echo('Passwords functionality not yet created.')

@cli.command()
def attachments():
    click.echo('Attachments functionality not yet created.')