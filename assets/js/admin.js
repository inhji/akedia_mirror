import Vue from 'vue'
import tags from 'bulma-tagsinput'

const app = new Vue({
  el: "form.vue",
  data: {
    charCount: 0,
    maxChars: 400,
    zenActive: false
  },
  mounted() {
    tags.attach()
  },
  methods: {
    updateCharCount(e) {
      const charCount = e.target.value.length
      this.charCount = charCount
    },
    closeZen() {
      this.zenActive = false
    }
  }
})
