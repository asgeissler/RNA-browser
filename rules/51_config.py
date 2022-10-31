import pandas as pd
import json


path_samples = 'samples.csv'
deploy_url = snakemake.config['deploy_url']
browser_short = snakemake.config['browser_short']
browser_name = snakemake.config['browser_name']

out = snakemake.output[0]


# Basic configuration of genome
res = {
    "assemblies": [
        {
            "name": browser_short,
            "sequence": {
                "type": "ReferenceSequenceTrack",
                "trackId": "{}-seq".format(browser_short),
                "adapter": {
                    "type": "IndexedFastaAdapter",
                    "fastaLocation": {
                        "locationType": "UriLocation",
                        "uri": "{}/files/genome.fna".format(deploy_url)
                    },
                    "faiLocation": {
                        "locationType": "UriLocation",
                        "uri": "{}/files/genome.fna.fai".format(deploy_url)
                    },
                },
                "displays": [
                    {
                        "type": "LinearReferenceSequenceDisplay",
                        "displayId": "{}-LinearReferenceSequenceDisplay".format(browser_short)
                    }
                ]
            },
            "displayName": browser_name,
        }
    ],
    "tracks": [
        {
            "type": "FeatureTrack",
            "trackId": "annotation",
            "name": "Annotation",
            "assemblyNames": [
                browser_short
            ],
            "adapter": {
                "type": "Gff3Adapter",
                "gffLocation": {
                    "locationType": "UriLocation",
                    "uri": "{}/files/genome.gff".format(deploy_url)
                }
            },
            "displays": [
                {
                    "type": "LinearBasicDisplay",
                    "displayId": "annotation-LinearBasicDisplay"
                },
                {
                    "type": "LinearArcDisplay",
                    "displayId": "annotation-LinearArcDisplay"
                }
            ]
        }
    ]
}


# Build multi-track per dataset
xs = pd.read_csv(path_samples)
xs['deploy_url'] = deploy_url


# In pair-end case, make rows unique per sample
if 'pair' in xs.columns:
    # Prevent listing files multiple times in track below due to the
    # pair/file columns
    del xs['pair']
    del xs['file']
    xs.drop_duplicates(inplace = True)



def sample_wise(df, x):
    "Expand wildcards in x as a generator"
    return list(df.apply(
        lambda row: x.format(**row),
        axis = 1
    ))


# Build multi-wig per dataset
for i in set(xs['dataset']):
    mask = xs['dataset'] == i
    track = {
        "type": "MultiQuantitativeTrack",
        "trackId": "multiwiggle_{}".format(i),
        "name": i,
        "assemblyNames": [
            browser_short
        ],
        "adapter": {
            "type": "MultiWiggleAdapter",
            "bigWigs": [
                *sample_wise(xs.loc[mask], '{deploy_url}/files/{condition}_{sample}_{dataset}.fwd.bw'),
                *sample_wise(xs.loc[mask], '{deploy_url}/files/{condition}_{sample}_{dataset}.rev.bw')
            ]
        },
        "displays": [
            {
            "type": "MultiLinearWiggleDisplay",
            "displayId": "multiwiggle_{}-MultiLinearWiggleDisplay".format(i)
            }
        ]
    }
    res['tracks'].append(track)


with open(out, 'w') as h:
    json.dump(res, h)
