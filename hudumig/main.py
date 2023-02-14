import click
from configparser import ConfigParser
import logging
from .utils import getExistingRecords, writeJson
from .modules.layouts import createlayouts

cfg = ConfigParser()
cfg.read('./config/config.ini')
ASSET_LAYOUTS_JSON = cfg['FILE']['ASSET_LAYOUTS_JSON']
ASSET_LAYOUTS_OUTPUT = cfg['FILE']['ASSET_LAYOUTS_OUTPUT']

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
@click.argument('layoutsJson', default=ASSET_LAYOUTS_JSON)
@click.option('-o','--output', is_flag=True, help='Output existing layouts in Json to [OUTPUTFILE] (occurs after creation if called in same command)')
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
def companies():
    click.echo('companies')