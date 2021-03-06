"""sender_ids

Revision ID: 2665f0674fa6
Revises: 528d57e92de7
Create Date: 2016-02-17 22:49:46.258507

"""

# revision identifiers, used by Alembic.
revision = '2665f0674fa6'
down_revision = '528d57e92de7'

from alembic import op
import sqlalchemy as sa


def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('messages', sa.Column('sender_email_id', sa.Integer(), nullable=True))
    op.add_column('messages', sa.Column('sender_user_id', sa.Integer(), nullable=True))
    op.drop_constraint(u'messages_sender_fkey', 'messages', type_='foreignkey')
    op.create_foreign_key(None, 'messages', 'addresses', ['sender_email_id'], ['id'])
    op.create_foreign_key(None, 'messages', 'users', ['sender_user_id'], ['id'])
    op.drop_column('messages', u'sender')
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('messages', sa.Column(u'sender', sa.INTEGER(), autoincrement=False, nullable=True))
    op.drop_constraint(None, 'messages', type_='foreignkey')
    op.drop_constraint(None, 'messages', type_='foreignkey')
    op.create_foreign_key(u'messages_sender_fkey', 'messages', u'addresses', [u'sender'], [u'id'])
    op.drop_column('messages', 'sender_user_id')
    op.drop_column('messages', 'sender_email_id')
    ### end Alembic commands ###
