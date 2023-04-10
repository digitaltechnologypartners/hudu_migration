from hudumig.settings import EXPORT_CON_STR
from hudumig.utils import getDf,writeLeftovers
from hudumig.cmdmods.assets import cleanAssets,getCompanyIDs

ENDPOINT = 'asset_passwords'

def getCompanyAssets(companyId):
    endpoint = 'companies/' + str(companyId) + '/assets'

def parsePws(pwJson,companyIds):
    parsedPws = []
    for pw in pwJson:
        ppw = {}
        ppw['company_id'] = companyIds[pw['company']]
        ppw['passwordable_type'] = pw['passwordable_type']


    return parsedPws

def createPasswords(query):
    companyIds = getCompanyIDs()
    pwdf = getDf(query,EXPORT_CON_STR)
    pwJson,leftovers = cleanAssets(pwdf,ENDPOINT)
    writeLeftovers(leftovers,ENDPOINT)
    parsedPws = parsePws(pwJson,companyIds)