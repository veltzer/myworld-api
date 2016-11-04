'''
dependencies for this project
'''

def populate(d):
    d.packs=[
        # for validating html
        'tidy',
    ]

def getdeps():
    return [
        __file__, # myself
    ]
