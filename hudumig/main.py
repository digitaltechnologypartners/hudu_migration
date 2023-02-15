import click
from configparser import ConfigParser
import logging
from .utils import getExistingRecords, writeJson
from .modules.layouts import createlayouts
from .modules.companies import createCompanies


cfg = ConfigParser()
cfg.read('./config/config.ini')
ASSET_LAYOUTS_JSON = cfg['ASSET_LAYOUTS']['ASSET_LAYOUTS_JSON']
ASSET_LAYOUTS_OUTPUT = cfg['ASSET_LAYOUTS']['ASSET_LAYOUTS_OUTPUT']
COMPANIES_OUTPUT = cfg['COMPANIES']['COMPANIES_OUTPUT']
COMPANIES_QUERY = cfg['COMPANIES']['COMPANIES_QUERY']

logger = logging.getLogger(__name__)
logging.basicConfig(filename='migrator.log', filemode='a', level=logging.INFO, format='%(asctime)s : %(levelname)s : %(message)s ', datefmt='%m/%d/%Y %I:%M:%S %p')

@click.group("cli")
def cli():
    pass

@cli.command()
def config():
    click.echo('config')

@cli.command()
@click.option('-c','--create', is_flag=True, help='Create asset layouts from [LAYOUTSJSON]')
@click.option('-o','--output', is_flag=True, help='Output existing layouts in Json to [OUTPUTFILE] (occurs after creation if called in same command)')
@click.option('-l','layoutsjson', default=ASSET_LAYOUTS_JSON, show_default=True, help='Declare file from which to read layouts and then write them')
@click.option('-f','outputFile', default=ASSET_LAYOUTS_OUTPUT, show_default=True, help='Declare file to output existing layouts to')
def layouts(create,output,layoutsjson,outputfile):
    """Create asset layouts and/or output existing layouts to a json file."""
    endpoint='asset_layouts'
    if create:
        createlayouts(layoutsjson)
        click.echo('Created layouts from ' + layoutsjson)
    else:
        click.echo('Nothing was created.')
    if output:
        layouts = getExistingRecords(endpoint)
        writeJson(layouts,outputfile)
        click.echo('Existing layouts exported to ' + outputfile)

@cli.command()
@click.option('-c','--create', is_flag=True, help='Create companies from specified source db based on --query')
@click.option('-s','--source', default='glue', type=click.Choice(['glue','manage'],case_sensitive=False), show_default=True, help='Declare the source database from which created companies should be pulled')
@click.option('-o','--output', is_flag=True, help='Output existing companies in Json to --outputfile (occurs after creation if called in same command)')
@click.option('-q', '--query', default=COMPANIES_QUERY, show_default=True, help='Declare file containing query to use to pull companies from database')
@click.option('-f','--outputfile', default=COMPANIES_OUTPUT, show_default=True, help='Declare file to output existing companies to')
def companies(create,source,output,query,outputfile):
    """Create companies and/or output existing companies to a json file"""
    endpoint='companies'
    if create:
        createCompanies(source,query)
    else:
        click.echo('Nothing was created.')
    if output:
        companies = getExistingRecords(endpoint)
        writeJson(companies,outputfile)
        click.echo('Existing companies exported to' + outputfile)

@cli.command()
@click.option('-c','--create', help='Create assets for specified ASSETTYPE from --query')
@click.option('-o','--output', help='Output existing assets for specified ASSETTYPE in Json to specified output file (occurs after creation if called in same command)')
@click.argument('assettype')
def assets(create,output,assettype):
    """Create assets for specified [ASSETTYPE] based on --query, and/or output exsiting assets for specified [ASSETTYPE] to a json file
    
    You must specify the Asset Type you wish to work with by exact case sensitive name as it appears in Hudu.
    
    You must also specify the query file each time you use the --create option, and the output file each time you use the --output option."""
    layouts = getExistingRecords('asset_layouts')
    found = False
    for layout in layouts:
        if layout['name'] == assettype:
            click.echo(layout['name'])
            found = True
    if found == False:
        click.echo('Asset Type not found.')
    else:
        if create:
            # create assets
            pass
        if output:
            # output assets
            pass