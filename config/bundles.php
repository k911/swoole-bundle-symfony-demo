<?php

declare(strict_types=1);
use Symfony\Bundle\FrameworkBundle\FrameworkBundle;
use K911\Swoole\Bridge\Symfony\Bundle\SwooleBundle;
use Sensio\Bundle\FrameworkExtraBundle\SensioFrameworkExtraBundle;
use Symfony\Bundle\MonologBundle\MonologBundle;
use Symfony\Bundle\TwigBundle\TwigBundle;
use Twig\Extra\TwigExtraBundle\TwigExtraBundle;
use Symplify\ConsoleColorDiff\ConsoleColorDiffBundle;

return [
    FrameworkBundle::class => ['all' => true],
    SwooleBundle::class => ['all' => true],
    SensioFrameworkExtraBundle::class => ['all' => true],
    MonologBundle::class => ['all' => true],
    TwigBundle::class => ['all' => true],
    TwigExtraBundle::class => ['all' => true],
    ConsoleColorDiffBundle::class => ['dev' => true, 'test' => true],
];
