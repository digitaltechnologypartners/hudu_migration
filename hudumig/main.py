import click
from configparser import ConfigParser
import logging
from .utils import getExistingRecords, writeJson
from .modules.layouts import createlayouts

cfg = ConfigParser()
cfg.read('./config/config.ini')
ASSET_LAYOUTS_JSON = cfg['FILE']['ASSET_LAYOUTS_JSON']
ASSET_LAYOUTS_OUTPUT = cfg['FILE']['ASSET_LAYOUTS_OUTPUT']
COMPANIES_OUTPUT = cfg['FILE']['COMPANIES_OUTPUT']
COMPANIES_QUERY = cfg['DATABASE']['COMPANIES_QUERY']

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
@click.argument('layoutsJson', default=ASSET_LAYOUTS_JSON)
@click.argument('outputFile', default=ASSET_LAYOUTS_OUTPUT)
def layouts(create,output,layoutsjson,outputfile):
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
@click.option('-c','--create', is_flag=True, help='Create companies from specified source db based on [QUERY]')
@click.option('-s','--source', default='glue', type=click.Choice(['glue','manage'],case_sensitive=False), show_default=True, help='Declare the source database from which created companies should be pulled')
@click.option('-o','--output', is_flag=True, help='Output existing companies in Json to [OUTPUTFILE] (occurs after creation if called in same command)')
@click.argument('query', default=COMPANIES_QUERY)
@click.argument('outputFile', default=COMPANIES_OUTPUT)
def companies(create,source,output,query,outputfile):
    endpoint='companies'
    if create:
        if create == 'glue':
            click.echo('glue')
        elif create == 'manage':
            click.echo('manage')
    