<template>
  <v-dialog v-model="display" :width="width" persistent :attach="attach">
    <v-card v-if="options" class="pa-10">
      <v-row no-gutters>
        <v-col cols="11">
          <h2 class="dialog-title">{{ options.title }}</h2>
          <div class="mt-10">
            <!-- can be replaced with <template v-slot:content> -->
            <slot name="content">
              <dialog-content
                :setBaseText="options.text"
                :setExtraText="options.textExtra"
                :setHasContactInfo="options.hasContactInfo"
              />
            </slot>
          </div>
        </v-col>
        <v-col cols="1">
          <v-btn class="close-btn float-right" color="primary" icon :ripple="false" @click="proceed(closeAction)">
            <v-icon size="32px">mdi-close</v-icon>
          </v-btn>
        </v-col>
      </v-row>
      <div class="mt-10 action-buttons">
        <!-- can be replaced with <template v-slot:buttons> -->
        <slot name="buttons">
          <dialog-buttons
            :setAcceptText="options.acceptText"
            :setCancelText="options.cancelText"
            :reverseButtons="reverseActionButtons"
            @proceed="proceed($event)"
          />
        </slot>
      </div>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
// external
import {
  computed,
  defineComponent,
  reactive,
  toRefs
} from 'vue-demi'
// local components
import DialogButtons from './common/DialogButtons.vue'
import DialogContent from './common/DialogContent.vue'
// local types/helpers/etc.
import { DialogOptionsIF } from '@/interfaces' // eslint-disable-line

export default defineComponent({
  name: 'BaseDialog',
  components: {
    DialogButtons,
    DialogContent
  },
  props: {
    setAttach: { type: String, default: '' },
    setDisplay: { type: Boolean, default: false },
    width: { type: String, default: '720px' },
    setOptions: Object as () => DialogOptionsIF,
    closeAction: { type: Boolean, default: false },
    reverseActionButtons: {
      type: Boolean,
      default: false
    }
  },
  emits: ['proceed'],
  setup (props, { emit }) {
    const localState = reactive({
      attach: computed(() => {
        return props.setAttach
      }),
      display: computed(() => {
        return props.setDisplay
      }),
      options: computed(() => {
        return props.setOptions
      })
    })

    const proceed = (val: boolean) => {
      emit('proceed', val)
    }

    return {
      proceed,
      ...toRefs(localState)
    }
  }
})
</script>

<style lang="scss" scoped>
@import '@/assets/styles/theme.scss';
.close-btn, .close-btn:hover, .close-btn::before {
  background-color: transparent;
  height: 24px;
  width: 24px;
}
</style>
