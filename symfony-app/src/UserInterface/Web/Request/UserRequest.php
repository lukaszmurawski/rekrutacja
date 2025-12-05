<?php

declare(strict_types=1);

namespace App\UserInterface\Web\Request;

use Symfony\Component\Validator\Constraints as Assert;

class UserRequest
{
    #[Assert\NotBlank]
    #[Assert\Type('string')]
    public string $first_name;

    #[Assert\NotBlank]
    #[Assert\Type('string')]
    public string $last_name;

    #[Assert\NotBlank]
    #[Assert\Date]
    public string $birthdate;

    #[Assert\NotBlank]
    #[Assert\Choice(['male', 'female'])]
    public string $gender;
}