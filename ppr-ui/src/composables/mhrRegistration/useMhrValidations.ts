import { MhrCompVal, MhrSectVal } from '@/composables/mhrRegistration/enums'

export const useMhrValidations = (validationState: any) => {
  /** Set specified flag */
  const setValidation = (section: MhrSectVal, component: MhrCompVal, isValid: boolean): void => {
    // Only sets specified flag if the section and component are part of the validation model
    if (validationState[section]?.value[component] !== undefined) {
      validationState[section].value[component] = isValid
    }
  }

  /** Get specified flag */
  const getValidation = (section: MhrSectVal, component: MhrCompVal): boolean => {
    return validationState[section].value[component]
  }

  /** Is true when all flags are true in specified section. */
  const getStepValidation = (section: MhrSectVal): boolean => {
    return validationState[section]
      ? Object.values(validationState[section].value).every(val => val)
      : null
  }

  /** Is true when app-wide validations is flagged and specified component is invalid . */
  const getSectionValidation = (section: MhrSectVal, component: MhrCompVal): boolean => {
    return validationState.reviewConfirmValid.value.validateSteps && !validationState[section].value[component]
  }

  /** Reset submission validations to default . */
  const resetAllValidations = (): void => {
    const sections = Object.keys(validationState) as MhrSectVal[]

    sections.forEach(section =>
      Object.keys(validationState[section].value).forEach(component =>
        setValidation(section, component as MhrCompVal, false)))

    // Default for ADD_EDIT_OWNERS_VALID -> OWNERS_VALID is true
    if (sections.includes(MhrSectVal.ADD_EDIT_OWNERS_VALID)) {
      setValidation(MhrSectVal.ADD_EDIT_OWNERS_VALID, MhrCompVal.OWNERS_VALID, true)
    }
  }

  /** Is true when input field ref is in error. */
  const hasError = (ref: any): boolean => {
    return ref?.hasError
  }

  /** Scroll to first SECTION tag that is invalid in specified flag block. */
  const scrollToInvalid = (flagSection: MhrSectVal, viewId: string): boolean => {
    // Create an array of the _ordered_ validation flags
    const flagBlockArr = Object.keys(validationState[flagSection].value)
      .map(key => validationState[flagSection].value[key])

    // Find the _first_ corresponding Section that is invalid in the specified view
    const view = document.getElementById(viewId)
    const invalidComponent = view?.getElementsByTagName('section')[flagBlockArr.indexOf(false)]

    // If there is an invalid component, scroll to it
    if (invalidComponent) {
      setTimeout(() => {
        invalidComponent.scrollIntoView({ block: 'start', inline: 'nearest', behavior: 'smooth' })
      }, 500)
      return false
    }
    return true
  }

  /** Scroll to first HEADER of invalid step in the view.
   *  If all steps are valid scroll to first Section that is invalid
   *  in the specified section area.
   */
  const scrollToInvalidReviewConfirm = (stepsValidation: Array<boolean>): boolean => {
    // Find the _first_ corresponding step that is invalid in the specified view
    const view = document.getElementById('mhr-review-confirm')
    const invalidStep = view?.getElementsByTagName('header')[stepsValidation.indexOf(false)]

    // If there is an invalid step, scroll to its header
    if (invalidStep) {
      setTimeout(() => {
        invalidStep.scrollIntoView({ block: 'start', inline: 'nearest', behavior: 'smooth' })
      }, 500)
      return false
    }

    return scrollToInvalid(MhrSectVal.REVIEW_CONFIRM_VALID, 'mhr-review-confirm-components')
  }

  return {
    MhrCompVal,
    MhrSectVal,
    hasError,
    setValidation,
    getValidation,
    getSectionValidation,
    getStepValidation,
    resetAllValidations,
    scrollToInvalid,
    scrollToInvalidReviewConfirm
  }
}
