"""This module provides the blueprint for the blocks API endpoints.

For more information please refer to the documentation on ReadTheDocs:
 - https://docs.bigchaindb.com/projects/server/en/latest/drivers-clients/
   http-client-server-api.html
"""
from flask import current_app
from flask_restful import Resource, reqparse

from bigchaindb.web.views.base import make_error


class BlockApi(Resource):
    def get(self, block_id):
        """API endpoint to get details about a block.

        Args:
            block_id (str): the id of the block.

        Return:
            A JSON string containing the data about the block.
        """

        pool = current_app.config['bigchain_pool']

        with pool() as bigchain:
            block = bigchain.get_block(block_id=block_id)

        if not block:
            return make_error(404)

        return block


class BlockListApi(Resource):
    def get(self):
        """API endpoint to get the related blocks for a transaction.

        Return:
            A ``list`` of ``block_id`` that may be filtered when provided
            a status query parameter: "valid", "invalid", "undecided".
        """
        parser = reqparse.RequestParser()
        parser.add_argument('tx_id', type=str, required=True)
        parser.add_argument('status', type=str, choices=['valid', 'invalid', 'undecided'])

        args = parser.parse_args(strict=True)
        tx_id = args['tx_id']
        status = args['status']

        pool = current_app.config['bigchain_pool']

        with pool() as bigchain:
            blocks = bigchain.get_blocks_status_containing_tx(tx_id)
            if blocks:
                if status:
                    blocks = {k: v for k, v in blocks.items() if v == status}
                blocks = list(blocks.keys())

        if not blocks:
            return make_error(404)

        return blocks
