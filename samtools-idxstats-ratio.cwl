{
    "class": "CommandLineTool",
    "cwlVersion": "v1.0",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "id": "gaonkark/cbttc-dev/samtools-idxstats-ratio/14",
    "baseCommand": [
        "samtools",
        "idxstats"
    ],
    "inputs": [
        {
            "id": "input_cram",
            "type": "File",
            "inputBinding": {
                "position": 0
            }
        },
        {
            "id": "threads",
            "type": "int",
            "inputBinding": {
                "position": 3,
                "prefix": "--threads",
                "shellQuote": false
            }
        }
    ],
    "outputs": [
        {
            "id": "output",
            "type": "File?",
            "outputBinding": {
                "glob": "*idxstats.txt",
                "outputEval": "$(inheritMetadata(self, inputs.input_cram))"
            }
        },
        {
            "id": "ratio",
            "type": "File?",
            "outputBinding": {
                "glob": "*ratio.txt",
                "outputEval": "$(inheritMetadata(self, inputs.input_cram))"
            }
        }
    ],
    "label": "samtools-idxstats-ratio",
    "arguments": [
        {
            "position": 100,
            "prefix": "",
            "separate": false,
            "shellQuote": false,
            "valueFrom": "&& cat $(inputs.input_cram.path.split('/').pop().split('.')[0]+\".idxstats.txt\") | awk '{if($1==\"chrX\") {x_rat = $3 / $2; X_reads=$3;}; if($1==\"chrY\") {y_rat = $3/$2; Y_reads = $3;}}END {print \"Y_reads_fraction\", Y_reads/(X_reads+Y_reads), \"\\nX:Y_ratio\", x_rat / y_rat,\"\\nX_norm_reads\", x_rat, \"\\nY_norm_reads\", y_rat, \"\\nY_norm_reads_fraction\", y_rat/(x_rat+y_rat)}' > $(inputs.input_cram.path.split('/').pop().split('.')[0]+\".ratio.txt\")"
        },
        {
            "position": 4,
            "prefix": ">",
            "shellQuote": false,
            "valueFrom": "${\nreturn inputs.input_cram.path.split('/').pop().split('.')[0]+\".idxstats.txt\"\n}"
        }
    ],
    "requirements": [
        {
            "class": "ShellCommandRequirement"
        },
        {
            "class": "DockerRequirement",
            "dockerPull": "kfdrc/samtools:1.9"
        },
        {
            "class": "InlineJavascriptRequirement",
            "expressionLib": [
                "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file))\n        file['metadata'] = metadata;\n    else {\n        for (var key in metadata) {\n            file['metadata'][key] = metadata[key];\n        }\n    }\n    return file\n};\n\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata = {};\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n        for (var key in example) {\n            if (i == 0)\n                commonMetadata[key] = example[key];\n            else {\n                if (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n                }\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1, commonMetadata)\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n        }\n    }\n    return o1;\n};"
            ]
        }
    ],
    "hints": [
        {
            "class": "sbg:AWSInstanceType",
            "value": "c4.2xlarge"
        },
        {
            "class": "sbg:maxNumberOfParallelInstances",
            "value": "4"
        }
    ],
    "sbg:projectName": "PBTA-Dev",
    "sbg:revisionsInfo": [
        {
            "sbg:revision": 0,
            "sbg:modifiedBy": "gaonkark",
            "sbg:modifiedOn": 1565787705,
            "sbg:revisionNotes": "Copy of gaonkark/cnmc-test-space/samtools-idxstats-ratio/3"
        },
        {
            "sbg:revision": 1,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565813703,
            "sbg:revisionNotes": "auto output name"
        },
        {
            "sbg:revision": 2,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565820990,
            "sbg:revisionNotes": "other ratio"
        },
        {
            "sbg:revision": 3,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565837806,
            "sbg:revisionNotes": "output name"
        },
        {
            "sbg:revision": 4,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565838236,
            "sbg:revisionNotes": "output_name"
        },
        {
            "sbg:revision": 5,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565839569,
            "sbg:revisionNotes": "add labels"
        },
        {
            "sbg:revision": 6,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565840558,
            "sbg:revisionNotes": "output name"
        },
        {
            "sbg:revision": 7,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565871640,
            "sbg:revisionNotes": "combine cats"
        },
        {
            "sbg:revision": 8,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565872662,
            "sbg:revisionNotes": "update suffix"
        },
        {
            "sbg:revision": 9,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565876586,
            "sbg:revisionNotes": "multiple if actions"
        },
        {
            "sbg:revision": 10,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565879569,
            "sbg:revisionNotes": "shellQuote"
        },
        {
            "sbg:revision": 11,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565889336,
            "sbg:revisionNotes": "remove spaces"
        },
        {
            "sbg:revision": 12,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565889485,
            "sbg:revisionNotes": "update spaces"
        },
        {
            "sbg:revision": 13,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565893362,
            "sbg:revisionNotes": "thread input"
        },
        {
            "sbg:revision": 14,
            "sbg:modifiedBy": "shrivatsk",
            "sbg:modifiedOn": 1565915796,
            "sbg:revisionNotes": "hint"
        }
    ],
    "sbg:image_url": null,
    "sbg:appVersion": [
        "v1.0"
    ],
    "sbg:id": "gaonkark/cbttc-dev/samtools-idxstats-ratio/14",
    "sbg:revision": 14,
    "sbg:revisionNotes": "hint",
    "sbg:modifiedOn": 1565915796,
    "sbg:modifiedBy": "shrivatsk",
    "sbg:createdOn": 1565787705,
    "sbg:createdBy": "gaonkark",
    "sbg:project": "gaonkark/cbttc-dev",
    "sbg:sbgMaintained": false,
    "sbg:validationErrors": [],
    "sbg:contributors": [
        "gaonkark",
        "shrivatsk"
    ],
    "sbg:latestRevision": 14,
    "sbg:publisher": "sbg",
    "sbg:content_hash": "acc44684a97540ac05605b6cee63c1cd0c75b1698619f1ba55bbd644e4e39a797"
}