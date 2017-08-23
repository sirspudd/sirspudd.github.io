---
layout: post
title:  "Using the AMD DC/DAL/WTFBBQ code on Arch, today"
date:   2017-06-04 12:10:59 -0700
published: true
tags: [gl, arch, linux, oss, amd]
---

# Introduction

I don't know of a single centralized source of information on how to consume the current AMD DAL/DC kernel module in the wild today; I might as well document this for myself and any other peanuts who want to jump on this train.

# TL&DR

* Grab current kernel code
* Grab AMD upstream repo
* Checkout specific files
* Build
* Profit

# The Nitty Gritty

* git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
* git remote add alex git://people.freedesktop.org/~agd5f/linux
* The kernel moves quickly, but dumping the source code into the right location is working for me, so what I would advocate. For 4.13, amd-staging-drm-next is the branch we want to be rummaging in. If you feel less like putting out fires, you might want to simply build one of Alex's other existing branches
* [The full list of touched files](#appendix). This resolves down to 3 paths

    * drivers/gpu/drm
    * include/drm
    * include/uapi/drm/amdgpu_drm.h

* which can be:

    * deleted
    * then checked out of their WIP branch with: git checkout alex/amd-staging-drm-next drivers/gpu/drm (for each path)
    * then added
    * birthing this [script](snippets/splice-amd-crud-into-mainline.sh)

* You will notice I am checking out the whole gpu/drm path. This means I am grabbing all changes for all gpus from the AMD devs, which may or may not be a bright idea as I assume they have to fix shit when they introduce API breakage. Descending one more level to amdgpu did not suffice to resolve build issues, so apply a little common sense and prudence before advertising the fruits of your labour as something edible, especially for a non-AMD audience.

Groovy, that is it; Enable DC in $(make menuconfig), [build your kernel](https://g.chaos-reins.com/Arch/linux-spudd/src/master/PKGBUILD) and away you go. Freesync may or may not be enabled on my rig, at least it is theoretically possible to get it functioning.

# Or

You can bypass this crud, assume full responsibility and choke on the linux-spudd package in:

        [qpi]
        SigLevel = Optional
        Server = http://s3.amazonaws.com/spuddrepo/repo/$arch

Clearly I assume no responsibility for any negative impact running a pre-release kernel with a pre-release driver does to anyone in your family. Go with god; you are on your own.

# Appendix

drivers/gpu/drm/Kconfig
drivers/gpu/drm/Makefile
drivers/gpu/drm/amd/amdgpu/Makefile
drivers/gpu/drm/amd/amdgpu/amdgpu.h
drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
drivers/gpu/drm/amd/amdgpu/amdgpu_ih.h
drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
drivers/gpu/drm/amd/amdgpu/amdgpu_powerplay.c
drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
drivers/gpu/drm/amd/amdgpu/cik.c
drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c
drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.h
drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c
drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
drivers/gpu/drm/amd/amdgpu/nbio_v7_0.h
drivers/gpu/drm/amd/amdgpu/psp_v10_0.c
drivers/gpu/drm/amd/amdgpu/psp_v10_0.h
drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
drivers/gpu/drm/amd/amdgpu/si.c
drivers/gpu/drm/amd/amdgpu/soc15.c
drivers/gpu/drm/amd/amdgpu/soc15.h
drivers/gpu/drm/amd/amdgpu/soc15d.h
drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
drivers/gpu/drm/amd/amdgpu/vce_v4_0.c
drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
drivers/gpu/drm/amd/amdgpu/vcn_v1_0.h
drivers/gpu/drm/amd/amdgpu/vega10_ih.c
drivers/gpu/drm/amd/amdgpu/vi.c
drivers/gpu/drm/amd/amdgpu/vid.h
drivers/gpu/drm/amd/include/amd_shared.h
drivers/gpu/drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h
drivers/gpu/drm/amd/include/asic_reg/raven1/DCN/dcn_1_0_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/DCN/dcn_1_0_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/DCN/dcn_1_0_sh_mask.h
drivers/gpu/drm/amd/include/asic_reg/raven1/GC/gc_9_1_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/GC/gc_9_1_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/GC/gc_9_1_sh_mask.h
drivers/gpu/drm/amd/include/asic_reg/raven1/MMHUB/mmhub_9_1_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/MMHUB/mmhub_9_1_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/MMHUB/mmhub_9_1_sh_mask.h
drivers/gpu/drm/amd/include/asic_reg/raven1/MP/mp_10_0_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/MP/mp_10_0_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/MP/mp_10_0_sh_mask.h
drivers/gpu/drm/amd/include/asic_reg/raven1/NBIO/nbio_7_0_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/NBIO/nbio_7_0_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/NBIO/nbio_7_0_sh_mask.h
drivers/gpu/drm/amd/include/asic_reg/raven1/SDMA0/sdma0_4_1_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/SDMA0/sdma0_4_1_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/SDMA0/sdma0_4_1_sh_mask.h
drivers/gpu/drm/amd/include/asic_reg/raven1/THM/thm_10_0_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/THM/thm_10_0_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/THM/thm_10_0_sh_mask.h
drivers/gpu/drm/amd/include/asic_reg/raven1/VCN/vcn_1_0_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/VCN/vcn_1_0_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/VCN/vcn_1_0_sh_mask.h
drivers/gpu/drm/amd/include/ivsrcid/irqsrcs_dcn_1_0.h
drivers/gpu/drm/amd/include/pptable.h
drivers/gpu/drm/amd/powerplay/eventmgr/eventmgr.c
drivers/gpu/drm/amd/powerplay/hwmgr/Makefile
drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
drivers/gpu/drm/amd/powerplay/hwmgr/pp_overdriver.c
drivers/gpu/drm/amd/powerplay/hwmgr/pp_overdriver.h
drivers/gpu/drm/amd/powerplay/hwmgr/processpptables.c
drivers/gpu/drm/amd/powerplay/hwmgr/rv_hwmgr.c
drivers/gpu/drm/amd/powerplay/hwmgr/rv_hwmgr.h
drivers/gpu/drm/amd/powerplay/hwmgr/rv_inc.h
drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.h
drivers/gpu/drm/amd/powerplay/hwmgr/vega10_pptable.h
drivers/gpu/drm/amd/powerplay/hwmgr/vega10_processpptables.c
drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
drivers/gpu/drm/amd/powerplay/inc/amd_powerplay.h
drivers/gpu/drm/amd/powerplay/inc/hwmgr.h
drivers/gpu/drm/amd/powerplay/inc/rv_ppsmc.h
drivers/gpu/drm/amd/powerplay/inc/smu10.h
drivers/gpu/drm/amd/powerplay/inc/smu10_driver_if.h
drivers/gpu/drm/amd/powerplay/inc/smu9_driver_if.h
drivers/gpu/drm/amd/powerplay/inc/smumgr.h
drivers/gpu/drm/amd/powerplay/smumgr/Makefile
drivers/gpu/drm/amd/powerplay/smumgr/rv_smumgr.c
drivers/gpu/drm/amd/powerplay/smumgr/rv_smumgr.h
drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
drivers/gpu/drm/amd/scheduler/gpu_scheduler.c
drivers/gpu/drm/amd/scheduler/gpu_scheduler.h
drivers/gpu/drm/arm/hdlcd_crtc.c
drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
drivers/gpu/drm/bridge/sii902x.c
drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
drivers/gpu/drm/drm_atomic.c
drivers/gpu/drm/drm_atomic_helper.c
drivers/gpu/drm/drm_color_mgmt.c
drivers/gpu/drm/drm_connector.c
drivers/gpu/drm/drm_dp_mst_topology.c
drivers/gpu/drm/drm_fb_cma_helper.c
drivers/gpu/drm/drm_file.c
drivers/gpu/drm/drm_irq.c
drivers/gpu/drm/drm_plane.c
drivers/gpu/drm/drm_plane_helper.c
drivers/gpu/drm/drm_prime.c
drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
drivers/gpu/drm/gma500/mdfld_tpo_vid.c
drivers/gpu/drm/gma500/psb_intel_lvds.c
drivers/gpu/drm/i915/gvt/handlers.c
drivers/gpu/drm/i915/gvt/render.c
drivers/gpu/drm/i915/gvt/sched_policy.c
drivers/gpu/drm/i915/i915_gem_gtt.c
drivers/gpu/drm/i915/i915_irq.c
drivers/gpu/drm/i915/i915_reg.h
drivers/gpu/drm/i915/intel_cdclk.c
drivers/gpu/drm/i915/intel_display.c
drivers/gpu/drm/i915/intel_dp_mst.c
drivers/gpu/drm/i915/intel_drv.h
drivers/gpu/drm/i915/intel_dsi.c
drivers/gpu/drm/i915/intel_hdmi.c
drivers/gpu/drm/i915/intel_lpe_audio.c
drivers/gpu/drm/i915/intel_sdvo.c
drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
drivers/gpu/drm/nouveau/nouveau_display.c
drivers/gpu/drm/nouveau/nouveau_display.h
drivers/gpu/drm/nouveau/nouveau_drm.c
drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c
drivers/gpu/drm/nouveau/nvkm/subdev/secboot/ls_ucode_gr.c
drivers/gpu/drm/pl111/Kconfig
drivers/gpu/drm/pl111/Makefile
drivers/gpu/drm/pl111/pl111_connector.c
drivers/gpu/drm/pl111/pl111_display.c
drivers/gpu/drm/pl111/pl111_drm.h
drivers/gpu/drm/pl111/pl111_drv.c
drivers/gpu/drm/qxl/qxl_display.c
drivers/gpu/drm/radeon/evergreen.c
drivers/gpu/drm/radeon/radeon.h
drivers/gpu/drm/radeon/radeon_drv.c
drivers/gpu/drm/radeon/radeon_irq_kms.c
drivers/gpu/drm/radeon/radeon_kms.c
drivers/gpu/drm/radeon/radeon_mode.h
drivers/gpu/drm/radeon/si.c
drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
drivers/gpu/drm/rockchip/rockchip_drm_drv.h
drivers/gpu/drm/rockchip/rockchip_drm_vop.c
drivers/gpu/drm/selftests/test-drm_mm.c
drivers/gpu/drm/sti/sti_cursor.c
drivers/gpu/drm/sti/sti_dvo.c
drivers/gpu/drm/sti/sti_gdp.c
drivers/gpu/drm/sti/sti_hda.c
drivers/gpu/drm/sti/sti_hdmi.c
drivers/gpu/drm/sti/sti_hqvdp.c
drivers/gpu/drm/sti/sti_mixer.c
drivers/gpu/drm/sti/sti_tvout.c
drivers/gpu/drm/sti/sti_vid.c
drivers/gpu/drm/stm/Kconfig
drivers/gpu/drm/stm/Makefile
drivers/gpu/drm/stm/drv.c
drivers/gpu/drm/stm/ltdc.c
drivers/gpu/drm/stm/ltdc.h
drivers/gpu/drm/tegra/drm.c
drivers/gpu/drm/vc4/Makefile
drivers/gpu/drm/vc4/vc4_bo.c
drivers/gpu/drm/vc4/vc4_crtc.c
drivers/gpu/drm/vc4/vc4_drv.c
drivers/gpu/drm/vc4/vc4_drv.h
drivers/gpu/drm/vc4/vc4_fence.c
drivers/gpu/drm/vc4/vc4_gem.c
drivers/gpu/drm/vc4/vc4_hdmi.c
drivers/gpu/drm/vc4/vc4_irq.c
drivers/gpu/drm/vc4/vc4_kms.c
drivers/gpu/drm/vc4/vc4_render_cl.c
drivers/gpu/drm/vc4/vc4_v3d.c
drivers/gpu/drm/vc4/vc4_validate.c
drivers/gpu/drm/vgem/vgem_drv.c
drivers/gpu/drm/vgem/vgem_drv.h
drivers/gpu/drm/zte/Makefile
drivers/gpu/drm/zte/zx_common_regs.h
drivers/gpu/drm/zte/zx_drm_drv.c
drivers/gpu/drm/zte/zx_drm_drv.h
drivers/gpu/drm/zte/zx_plane.c
drivers/gpu/drm/zte/zx_plane_regs.h
drivers/gpu/drm/zte/zx_vga.c
drivers/gpu/drm/zte/zx_vga_regs.h
drivers/gpu/drm/zte/zx_vou.c
drivers/gpu/drm/zte/zx_vou_regs.h
drivers/gpu/host1x/Kconfig
include/drm/drmP.h
include/drm/drm_atomic.h
include/drm/drm_blend.h
include/drm/drm_color_mgmt.h
include/drm/drm_connector.h
include/drm/drm_crtc.h
include/drm/drm_dp_helper.h
include/drm/drm_dp_mst_helper.h
include/drm/drm_drv.h
include/drm/drm_fb_cma_helper.h
include/drm/drm_gem_cma_helper.h
include/drm/drm_irq.h
include/drm/drm_prime.h
include/uapi/drm/amdgpu_drm.h

