<template>
  <draggable id="app" :options="{group: 'lists'}" class="row dragArea" @end="listMoved">
    <div v-for="(list, index) in lists" class="col-3">
    <h6>{{ list.name }}</h6>
    <hr />

        <div v-for="(card, index) in list.cards" class="card card-body mb-3">
          {{ card.name }}
        </div>

        <div class="card card-body">
          <textarea v-model="messages[list.id]" class="form-control"></textarea>
          <button v-on:click="submitMessages(list.id)" class="btn btn-secondary">Add</button>
        </div>
    </div>
  </draggable>
</template>

<script>
import draggable from "vuedraggable"

export default {
  components: { draggable }, // gives access to draggable tag above when we render our template.
  props: ["original_lists"],
  data: function () {
    return {
      messages: {},
      lists: this.original_lists
      // puts copy of lists from parent into component for manipulating
    }
  },
  methods: {
    listMoved: function(event) {
      var data = new FormData
      console.log('This is data before: ',data)
      // console.log('This is event: ',event)
      // console.log('This is this.lists: ', this.lists)
      data.append("list[position]", event.newIndex + 1)
      console.log('This is data after: ',data)
      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
    },
    submitMessages: function(list_id) {
      var data = new FormData
      data.append("card[list_id]", list_id)
      data.append("card[name]", this.messages[list_id])

      Rails.ajax({
        url: "/cards",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          const index = this.lists.findIndex(item => item.id == list_id)
          // when we drag and drop cards, we need to look up which list has the right id in the lists array
          this.lists[index].cards.push(data) // will append item to the proper list
          this.messages[list_id] = undefined
        }
      })
    }
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 20px; 
}
</style>
// makes drag area visible so that you know that you can drop card there
