module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :delete_all
  end

  def create_comment(content, creator)
    comment = self.comments.create(content:content, creator: creator)
    if comment
      event_data = {
      action_desc: Event::DESC_COMMENT_ADD,
      action_label: Event::LABEL_COMMENT_ADD,
      action_type: "comment",
      comment_id: comment.id,
      comment_content: content,
      }
      build_event(creator.id, event_data)
    end
    self
  end

  private

  def build_event(actor_id, event_data)
    @event_params = {
      actor_id: actor_id,
      ancestor_id: self.project.id,
      ancestor_type: "Project",
      action_desc: "",
      action_label: "",
      invoke_item_type: self.class.name,
      invoke_item_id: self.id
    }

    @event_params.merge!(event_data)
    Event.create(@event_params)
  end
end
